module processor

import freeflowuniverse.baobab.jobs
import freeflowuniverse.crystallib.redisclient

import encoding.base64
import json
import time

pub fn error_code_to_message(code RMBErrorCode) string {
	match code {
		.failed_decoding_payload_to_job {
			return 'Failed to decode the received payload to job. It should contain the base64 encoded representation of a json job.'
		}
		.unauthorized {
			return 'Unauthorized to execute the job. Make sure that the source and desition twin ids of the rmb message match the ones from the job.'
		}
		.internal_error {
			return 'Internal error. Make sure to report the error on https://github.com/threefoldtech/farmerbot/issues.'
		}
	}
}

pub enum RMBErrorCode as u8 {
	failed_decoding_payload_to_job
	unauthorized
	internal_error
}

struct RMBMessage {
pub mut:
	ver int = 1
	cmd string
	src string
	ref string
	exp u64
	dat string
	ret string
	now u64
	shm string
}

pub struct RMBResponse {
pub mut:
	ver int = 1
	ref string
	dat string
	dst string
	shm string
	now u64
}

pub struct RMBError {
pub mut:
	ver int = 1
	ref string
	dat string
	dst string
	shm string
	now u64
	err struct {
		code    int
		message string
	}
}

// listens to rmb queue for incoming execute job messages
// parses message into job saves job and message, returns optional guid
fn (mut p Processor) get_rmb_job(mut q_rmb redisclient.RedisQueue) ?string {
	// incoming jobs from rmb peer
	encoded_msg := q_rmb.pop() or { '' }

	if encoded_msg != '' {
		msg := json.decode(RMBMessage, encoded_msg) or {
			p.logger.error('Failed decoding ${encoded_msg} to RMBMessage: ${err}')
			return none
		}
		decoded_job := base64.decode_str(msg.dat)
		job := jobs.json_load(decoded_job) or {
			p.logger.error('Failed decoding ${decoded_job} to Job: ${err}')
			p.send_rmb_error_message(.failed_decoding_payload_to_job, msg)
			return none
		}
		if job.src_twinid != msg.src.u32() {
			p.logger.error('Job is either not meant for us or the sender is not who they claim to be: ${encoded_msg}')
			p.send_rmb_error_message(.unauthorized, msg)
			return none
		}
		// save job
		p.client.job_set(job) or {
			p.logger.error('Failed setting ${job}: ${err}')
			p.send_rmb_error_message(.internal_error, msg)
			return none
		}
		// save message
		p.client.redis.hset('rmb.db', '${job.guid}', encoded_msg) or {
			p.logger.error('Failed setting ${job.guid} in hset rmb.db: ${err}')
			p.send_rmb_error_message(.internal_error, msg)
			return none
		}
		return job.guid
	}
	return none
}

fn (mut p Processor) send_rmb_error_message(code RMBErrorCode, msg &RMBMessage) {
	mut q_return := p.client.redis.queue_get(msg.ret)
	response := RMBError {
		dst: msg.src
		ref: msg.ref
		now: u64(time.now().unix_time())
		shm: 'application/json'
		err: struct {
			code: int(code)
			message: error_code_to_message(code)
		}
	}
	q_return.add(json.encode(response)) or {
		p.logger.error('Failed sending back RMB error message')
	}
}

// return_job returns a job by placing it to the correct redis return queue
fn (mut p Processor) return_job_rmb(guid string) ! {
	job := p.client.job_get(guid)!

	// get message from rmb.db, set data to returned job
	mut encoded_msg := p.client.redis.hget('rmb.db', guid)!
	mut msg := json.decode(RMBMessage, encoded_msg)!
	mut q_return := p.client.redis.queue_get(msg.ret)
	response := RMBResponse {
		dst: msg.src
		dat: base64.encode_str(job.json_dump())
		ref: msg.ref
		now: u64(time.now().unix_time())
		shm: 'application/json'
	}
	q_return.add(json.encode(response))!
}
