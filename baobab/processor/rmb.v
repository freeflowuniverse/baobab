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
	dst []u32
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
	now u64
}

// listens to rmb queue for incoming execute job messages
// parses message into job saves job and message, returns optional guid
fn (mut p Processor) get_rmb_job() ?string {
	// incoming jobs from rmb peer
	mut q_rmb := p.client.redis.queue_get('msgbus.execute_job')
	encoded_msg := q_rmb.pop() or { '' }

	if encoded_msg != '' {
		msg := json.decode(RMBMessage, encoded_msg) or { panic(err) }
		job := jobs.json_load(base64.decode_str(msg.dat)) or { panic(err) }
		p.client.job_set(job) or { panic(err) } // save job
		p.client.redis.hset('rmb.db', '${job.guid}', encoded_msg) or { panic(err) } // save message
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
	}
	q_return.add(json.encode(response))!
}
