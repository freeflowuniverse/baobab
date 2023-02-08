module processor

import freeflowuniverse.baobab.jobs
import json

struct RMBMessage {
mut:
	version    u64    [json: ver]
	reference  string [json: ref]
	source     string [json: src]
	command    string [json: cmd]
	expiration u64    [json: exp]
	data       string [json: dat]
	tags       string [json: tag]
	reply_to   string [json: ret]
	schema     string [json: shm]
	timestamp  u64    [json: now]
}

// listens to rmb queue for incoming execute job messages
// parses message into job saves job and message, returns optional guid
fn (mut p Processor) get_rmb_job() ?string {
	// incoming jobs from rmb peer
	mut q_rmb := p.client.redis.queue_get('msgbus.execute_job')
	encoded_msg := q_rmb.pop() or { '' }

	if encoded_msg != '' {
		msg := json.decode(RMBMessage, encoded_msg) or { panic(err) }
		job := jobs.json_load(msg.data) or { panic(err) }
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
	msg.data = job.json_dump()

	mut q_return := p.client.redis.queue_get('msgbus.system.reply')
	q_return.add(json.encode(msg))!
}
