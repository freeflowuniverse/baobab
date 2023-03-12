module processor

import log
import freeflowuniverse.baobab.client
import freeflowuniverse.baobab.jobs
// import os
// import time

[noinit]
pub struct Processor {
mut:
	client client.Client
	errors []IError
	logger &log.Logger
pub mut:
	running bool
}

pub fn new(redis_address string, logger &log.Logger) !Processor {
	return Processor{
		client: client.new(redis_address)!
		logger: unsafe { logger }
	}
}

// run listens redis queues for incoming jobs, assigns jobs to actors,
// returns error and result responses from actor to caller of job
pub fn (mut p Processor) run() {
	p.logger.info('Processor is running')

	mut q_in := p.client.redis.queue_get('jobs.processor.in')
	mut q_error := p.client.redis.queue_get('jobs.processor.error')
	mut q_result := p.client.redis.queue_get('jobs.processor.result')

	p.running = true
	for p.running {
		// get guid from processor.in queue and assign job to actor
		if guid_in := q_in.get(1) {
			p.logger.debug('Received job ${guid_in}')
			p.assign_job(guid_in) or { p.handle_error(err) }
		}

		// get msg from rmb queue, parse job, assign to actor
		if guid_rmb := p.get_rmb_job() {
			p.logger.debug('Received job ${guid_rmb} from RMB')
			p.assign_job(guid_rmb) or { p.handle_error(err) }
		}

		// get guid from processor.error queue and move to return queue
		if guid_error := q_error.get(1) {
			p.logger.debug('Received error response for job: ${guid_error} ')
			p.return_job(guid_error) or { p.handle_error(err) }
		}

		// get guid from processor.result queue and move to return queue
		if guid_result := q_result.get(1) {
			p.logger.debug('Received result for job: ${guid_result}')
			p.return_job(guid_result) or { p.handle_error(err) }
		}
	}
}

// assign_job places guid to correct actor queue, and to the processor.active queue
fn (mut p Processor) assign_job(guid string) ! {
	mut job := p.client.job_get(guid)!

	if !job.check_timeout_ok() {
		return jobs.JobError{
			msg: 'Job timeout reached'
			job_guid: guid
		}
	}

	// push guid to active queue
	mut q_active := p.client.redis.queue_get('jobs.processor.active')
	q_active.add(guid)!

	// push guid to queue of actor which will handle job
	q_key := 'jobs.actors.${job.action.all_before_last('.')}'
	mut q_actor := p.client.redis.queue_get(q_key)
	q_actor.add(guid)!

	p.logger.debug('Assigned job ${guid} to ${q_key}:')
	p.logger.debug('${job}\n')
}

// return_job returns a job by placing it to the correct redis return queue
fn (mut p Processor) return_job(guid string) ! {
	if p.client.redis.hexists('rmb.db', guid)! {
		p.return_job_rmb(guid)!
	} else {
		mut q_return := p.client.redis.queue_get('jobs.return.${guid}')
		q_return.add(guid)!
	}
	p.logger.debug('Returned job ${guid}')
}

// handle_error places guid to jobs.return queue with an error
fn (mut p Processor) handle_error(error IError) {
	if error is jobs.JobError {
		mut job := p.client.job_get(error.job_guid) or {
			eprintln('Failed getting the job with id ${error.job_guid}: ${err}')
			return
		}
		p.client.job_error_set(mut job, error.msg) or {
			eprintln('Failed modifying the status of the job ${error.job_guid} to error: ${err}')
			return
		}
		p.return_job(error.job_guid) or {
			eprintln('Failed returning the job ${error.job_guid}: ${err}')
			return
		}
	} else {
		eprintln('Not a JobError: ${error}')
	}
}

pub fn (mut p Processor) reset() ! {
	p.client.redis.flushall()!
	p.client.redis.disconnect()
	p.client.redis.socket_connect()!
}

// todo: fix if needed
// fn (mut p Processor) restart()! {
// 	p.client.redis.save()!
// 	p.client.redis.shutdown()!
// 	// os.execute('redis-server --daemonize yes &')
// 	time.sleep(1000000)
// 	p.client.redis.socket_connect()!
// }
