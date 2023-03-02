module processor

import freeflowuniverse.baobab.jobs

import encoding.base64
import json
import time

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

struct RMBResponse {
pub mut:
	ver int = 1
	ref string
	dat string
	dst string
	shm string
	now u64
}
struct RMBError {
pub mut:
	code int
	message string
}

// listens to rmb queue for incoming execute job messages
// parses message into job saves job and message, returns optional guid
fn (mut p Processor) get_rmb_job() ?string {
	// incoming jobs from rmb peer
	mut q_rmb := p.client.redis.queue_get('msgbus.execute_job')
	encoded_msg := q_rmb.pop() or { '' }

	if encoded_msg != '' {
		msg := json.decode(RMBMessage, encoded_msg) or {
			eprintln("Failed decoding ${encoded_msg} to RMBMessage: $err")
			return none
		}
		decoded_job := base64.decode_str(msg.dat)
		job := jobs.json_load(decoded_job) or { 
			eprintln("Failed decoding ${decoded_job} to Job: $err")
			// TODO return RMB error
			return none
		}
		if p.client.twinid != job.twinid || job.src_twinid != msg.src.u32() {
			eprintln("Job is either not meant for us or the sender is not who they claim to be: $encoded_msg")
			// TODO return RMB error
			return none
		}
		// save job
		p.client.job_set(job) or {
			eprintln("Failed setting ${job}: $err")
			// TODO return job error
			return none
		}
		// save message
		p.client.redis.hset('rmb.db', '${job.guid}', encoded_msg) or { 
			eprintln("Failed setting ${job.guid} in hset rmb.db: $err")
			// TODO return job error
			return none
		}
		return job.guid
	}
	return none
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
		shm: "application/json"
	}
	q_return.add(json.encode(response))!
}
