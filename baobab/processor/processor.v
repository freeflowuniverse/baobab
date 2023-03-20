module processor

import freeflowuniverse.baobab.client
import freeflowuniverse.baobab.jobs
import log
import time

[noinit]
pub struct Processor {
mut:
	//client client.Client
	errors []IError
	logger &log.Logger
pub mut:
	running bool
	redis_address string
}

pub fn new(redis_address string, logger &log.Logger) !Processor {
	return Processor{
		redis_address: redis_address
		//client: client.new(redis_address)!
		logger: unsafe { logger }
	}
}

// run listens redis queues for incoming jobs, assigns jobs to actors,
// returns error and result responses from actor to caller of job
pub fn (mut p Processor) run() {
	p.logger.info('Processor is running')
	p.running = true

	t1 := spawn p.handle_in()
	t2 := spawn p.handle_rmb()
	t3 := spawn p.handle_errors()
	t4 := spawn p.handle_results()

	t1.wait()
	t2.wait()
	t3.wait()
	t4.wait()
}

fn (mut p Processor) handle_in() {
	mut client_ := client.new(p.redis_address) or {
		return
	}
	for p.running {
		// get guid from processor.in queue and assign job to actor
		guid_in := client_.redis.brpop('jobs.processor.in', 1) or { '' }
		if guid_in != '' {
			p.logger.debug('Received job ${guid_in}')
			p.assign_job(mut client_, guid_in) or { p.handle_error(mut client_, err) }
		}
	}
}

fn (mut p Processor) handle_rmb(){
	mut client_ := client.new(p.redis_address) or {
		return
	}
	for p.running {
		// get msg from rmb queue, parse job, assign to actor
		if guid_rmb := p.get_rmb_job(mut client_) {
			p.logger.debug('Received job ${guid_rmb} from RMB')
			p.assign_job(mut client_, guid_rmb) or { p.handle_error(mut client_, err) }
		}
	}
}

fn (mut p Processor) handle_errors() {
	mut client_ := client.new(p.redis_address) or {
		return
	}
	for p.running {
		// get guid from processor.error queue and move to return queue
		guid_error := client_.redis.brpop('jobs.processor.error', 1) or { '' }
		if guid_error != '' {
			p.logger.debug('Received error response for job: ${guid_error} ')
			p.return_job(mut client_, guid_error) or { p.handle_error(mut client_, err) }
		}
	}
}

fn (mut p Processor) handle_results(){
	mut client_ := client.new(p.redis_address) or {
		return
	}
	for p.running {
		// get guid from processor.result queue and move to return queue
		guid_result := client_.redis.brpop('jobs.processor.result', 1) or { '' }
		if guid_result != '' {
			p.logger.debug('Received result for job: ${guid_result}')
			p.return_job(mut client_, guid_result) or { p.handle_error(mut client_, err) }
		}
		//time.sleep(100 * time.millisecond)
	}
}

// assign_job places guid to correct actor queue, and to the processor.active queue
fn (mut p Processor) assign_job(mut client_ client.Client, guid string) ! {
	mut job := client_.job_get(guid)!

	if !job.check_timeout_ok() {
		return jobs.JobError{
			msg: 'Job timeout reached'
			job_guid: guid
		}
	}

	// push guid to active queue
	mut q_active := client_.redis.queue_get('jobs.processor.active')
	q_active.add(guid)!

	// push guid to queue of actor which will handle job
	q_key := 'jobs.actors.${job.action.all_before_last('.')}'
	mut q_actor := client_.redis.queue_get(q_key)
	q_actor.add(guid)!

	p.logger.debug('Assigned job ${guid} to ${q_key}:')
	p.logger.debug('${job}\n')
}

// return_job returns a job by placing it to the correct redis return queue
fn (mut p Processor) return_job(mut client_ client.Client, guid string) ! {
	if client_.redis.hexists('rmb.db', guid)! {
		p.return_job_rmb(mut client_, guid)!
	} else {
		mut q_return := client_.redis.queue_get('jobs.return.${guid}')
		q_return.add(guid)!
	}
	p.logger.debug('Returned job ${guid}')
}

// handle_error places guid to jobs.return queue with an error
fn (mut p Processor) handle_error(mut client_ client.Client, error IError) {
	if error is jobs.JobError {
		mut job := client_.job_get(error.job_guid) or {
			eprintln('Failed getting the job with id ${error.job_guid}: ${err}')
			return
		}
		client_.job_error_set(mut job, error.msg) or {
			eprintln('Failed modifying the status of the job ${error.job_guid} to error: ${err}')
			return
		}
		p.return_job(mut client_, error.job_guid) or {
			eprintln('Failed returning the job ${error.job_guid}: ${err}')
			return
		}
	} else {
		eprintln('Not a JobError: ${error}')
	}
}

pub fn (mut p Processor) reset() ! {
	mut client_ := client.new(p.redis_address) or {
		return
	}
	client_.redis.flushall()!
	client_.redis.disconnect()
	client_.redis.socket_connect()!
}

// todo: fix if needed
// fn (mut p Processor) restart()! {
// 	client_.redis.save()!
// 	client_.redis.shutdown()!
// 	// os.execute('redis-server --daemonize yes &')
// 	time.sleep(1000000)
// 	client_.redis.socket_connect()!
// }
