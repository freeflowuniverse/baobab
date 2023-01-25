module processor

import freeflowuniverse.baobab.jobs
import freeflowuniverse.crystallib.redisclient

const (
	// todo
	redis_addr = ''
)

struct Processor {
mut:
	redis redisclient.Redis = redisclient.core_get()
}

//comment
fn (mut p Processor) run() {

	// queues that the processor listens to
	q_in := p.redis.queue_get('processor.in')
	q_error := p.redis.queue_get('processor.error')
	q_result := p.redis.queue_get('processor.result')

	for {

		// get guid from processor.in queue and assign to actor
		guid_in := q_in.redis.rpop(q_in.key) or {handle_error(err)}
		if guid_in != '' { p.assign_job(guid) or {handle_error(err)}}

		// get guid from processor.error queue and move to return queue
		guid_error := q_error.redis.rpop(q_error.key) or {handle_error(err)}
		if guid_error != '' { p.return_job(guid) }

		// get guid from processor.result queue and move to return queue
		guid_result := q_result.redis.rpop(q_result.key) or {handle_error(err)}
		if guid_result != '' { p.return_job(guid) }

	}
}

// assign_job places guid to correct actor queue
fn (mut p Processor) assign_job(guid string) ! {

	// check if job is valid
	validate_job(guid) or { return_job(guid) }
	job_encoded := r.hget('jobs.db', guid)!//?
	job := jobs.json_load(job_encoded)

	// gets the queue to the actor which will handle job
	// passes guid to actor queue
	mut action_parts := job.action.split('.')
	q_key := 'jobs.actors.${action_parts[..action_parts.len-1]}'
	q_actor := p.redis.queue_get(q_key)
	q_actor.add(guid)!
}

// handle_job places guid to correct queue with an error
fn (mut p Processor) return_job(guid string) ! {
	// check if job is valid
	validate_job(guid) or { return_job(guid) }
	job_encoded := r.hget('jobs.db', guid)!
	job := jobs.json_load(job_encoded)

	//? pass guid to guid queue?
	// gets the queue return queue for job and passes guid
	q_return := p.redis.queue_get('jobs.return.$guid')
	q_return.add(guid)!
}

fn (mut p Processor) validate_job(guid string) ! {

	job_encoded := r.hget('jobs.db', guid) or { handle_error(err) }
	if job_encoded == '' { return error('guid not found in db') }
	actionjob := jobs.json_load() !

	//todo: check process valid
	//if 
	// todo set job error
	return error()
}

// handle_error places guid to jobs.return queue with an error
fn (mut p Processor) handle_error(error IError) {
	println('Error: $err')
	
}