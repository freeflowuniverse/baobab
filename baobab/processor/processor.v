module processor

import freeflowuniverse.baobab.baobab.jobs
import freeflowuniverse.baobab.baobab.client
import freeflowuniverse.crystallib.redisclient

const (
	// todo
	redis_addr = ''
)

struct Processor {
mut:
	client client.Client = client.new()! //?ref?
}

//comment
fn (mut p Processor) run() ! {

	// queues that the processor listens to
	mut q_in := p.client.redis.queue_get('processor.in')
	mut q_error := p.client.redis.queue_get('processor.error')
	mut q_result := p.client.redis.queue_get('processor.result')

	for {

		// get guid from processor.in queue and assign to actor
		guid_in := q_in.pop()!
		if guid_in != '' { p.assign_job(guid_in)!}

		// get guid from processor.error queue and move to return queue
		guid_error := q_error.pop()!
		if guid_error != '' { p.return_job(guid_error)! }

		// get guid from processor.result queue and move to return queue
		guid_result := q_result.pop()!
		if guid_result != '' { p.return_job(guid_result)! }

	}
}

// assign_job places guid to correct actor queue
fn (mut p Processor) assign_job(guid string) ! {
	job := p.client.job_get(guid)!

	// gets the queue to the actor which will handle job
	// passes guid to actor queue
	mut action_parts := job.action.split('.')
	q_key := 'jobs.actors.${action_parts[..action_parts.len-1]}'
	mut q_actor := p.client.redis.queue_get(q_key)
	q_actor.add(guid)!
}

// handle_job places guid to correct queue with an error
fn (mut p Processor) return_job(guid string) ! {
	// gets the queue return queue for job and passes guid
	mut q_return := p.client.redis.queue_get('jobs.return.$guid')
	q_return.add(guid)!
}

// handle_error places guid to jobs.return queue with an error
fn (mut p Processor) handle_error(error IError, guid string) ! {
	println('Error: $error')
	//? how to handle jobs that dont exist in db
	mut job := p.client.job_get(guid) or { return }
	job.error = error.msg
	job.state = .error
	p.client.job_set(job) or { return }
	p.return_job(guid)!
}