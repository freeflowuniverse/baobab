module processor

import freeflowuniverse.baobab.client

pub struct Processor {
mut:
	client   client.Client = client.new()!
}

// run listens to processor.in/.error/.result queues, assigns incoming jobs to actors,
// returns error and result responses from actor to client
pub fn (mut p Processor) run() {
	// queues that the processor listens to
	mut q_in := p.client.redis.queue_get('jobs.processor.in')
	mut q_error := p.client.redis.queue_get('jobs.processor.error')
	mut q_result := p.client.redis.queue_get('jobs.processor.result')

	for {
		// get guid from processor.in queue and assign job to actor
		guid_in := q_in.pop() or { '' }
		if guid_in != '' {
			p.assign_job(guid_in) or { panic(err) }
		}

		// get msg from rmb queue, parse job, assign to actor
		if guid_rmb := p.get_rmb_job() {
			p.assign_job(guid_rmb) or { panic(err) }
		}

		// get guid from processor.error queue and move to return queue
		guid_error := q_error.pop() or { '' }
		if guid_error != '' {
			p.return_job(guid_error) or { panic(err) }
		}

		// get guid from processor.result queue and move to return queue
		guid_result := q_result.pop() or { '' }
		if guid_result != '' {
			p.return_job(guid_result) or { panic(err) }
		}
	}
}

// assign_job places guid to correct actor queue, and to the processor.active queue
fn (mut p Processor) assign_job(guid string) ! {
	mut job := p.client.job_get(guid)!
	if !job.check_timeout_ok() {
		return error('Job timeout reached')
	}

	// push guid to active queue
	mut q_active := p.client.redis.queue_get('jobs.processor.active')
	q_active.add(guid)!

	// push guid to queue of actor which will handle job
	q_key := 'jobs.actors.${job.action.all_before_last('.')}'
	mut q_actor := p.client.redis.queue_get(q_key)
	q_actor.add(guid)!
}

// return_job returns a job by placing it to the correct redis return queue
fn (mut p Processor) return_job(guid string) ! {
	if p.client.redis.hexists('rmb.db', guid)! {
		p.return_job_rmb(guid)!
	} else {
		mut q_return := p.client.redis.queue_get('jobs.return.${guid}')
		q_return.add(guid)!
	}
}

// handle_error places guid to jobs.return queue with an error
fn (mut p Processor) handle_error(error IError, guid string) ! {
	println('Error: ${error}')
	//? how to handle jobs that dont exist in db
	mut job := p.client.job_get(guid) or { return }
	job.error = error.msg()
	job.state = .error
	p.client.job_set(job) or { return }
	p.return_job(guid)!
}
