module actionrunner

import freeflowuniverse.baobab.actor
import freeflowuniverse.baobab.client { Client }
import freeflowuniverse.baobab.jobs { ActionJob }

import rand

// Actionrunner listens to jobs in an actors queue
// executes the jobs internally
// sets the status of the job in jobs.db in the process
// then moves jobs into processor.error/result queues
[heap]
pub struct ActionRunner {
pub mut:
	actors  []&actor.IActor
	client  &Client
	running bool
}

// factory function for actionrunner
pub fn new(client_ Client, actors []&actor.IActor) ActionRunner {
	mut ar := ActionRunner {
		actors: actors
		client: &client_
	}
	return ar
}

pub fn (mut ar ActionRunner) run() {
	ar.running = true
	mut queues_actors := ar.actors.map('jobs.actors.${it.name}')
	// go over jobs.actors in redis, see which jobs we have pass them onto the execute
	for ar.running {
		rand.shuffle[string](mut queues_actors) or {
			eprintln("Failed to shuffle actor queues")
		}
		// pull jobs for our actors: first one in the queues of our actors will be executed continue after 
		res := ar.client.redis.brpop(queues_actors, 1) or {
			eprintln('Failed checking job process: ${err}')
			continue
		}
		if res.len == 0 {
			// no jobs in queues
			continue
		}
		if res.len != 2 {
			eprintln('Expected 2 items in result of brpop!')
			continue
		}
		mut job := ar.client.job_get(res[1]) or {
			eprintln('Failed getting job from db: ${err}')
			continue
		}
		ar.execute(mut job) or { eprintln('Failed to execute the job: ${err}') }
	}
}

// execute calls execute_internal and handles error/result
pub fn (mut ar ActionRunner) execute(mut job ActionJob) ! {
	$if debug {
		eprintln('Executing job: ${job.guid}')
	}

	ar.execute_internal(mut job) or {
		// means there was error
		ar.job_error(mut job, err.msg())!
		return
	}
	ar.job_result(mut job)! // job was succesful
	$if debug {
		eprintln('Execution finished: ${job.guid}')
	}
}

// execute_internal matches job with actor, and calls actor.execute to execute job
fn (mut ar ActionRunner) execute_internal(mut job ActionJob) ! {
	// match actionjob with correct actor
	mut actor_ := ar.actors.filter(job.action.starts_with(it.name))
	if actor_.len == 1 {
		ar.client.job_status_set(mut job, .active)!
		actor_[0].execute(mut job)!
		return
	}
	// todo: handle multiple actor case

	return error('could not find actor to execute on the job')
}

fn (mut ar ActionRunner) job_error(mut job ActionJob, errmsg string) ! {
	job.error = errmsg
	ar.client.job_status_set(mut job, .error)!

	// add job to processor.error queue
	mut q_error := ar.client.redis.queue_get('jobs.processor.error')
	q_error.add(job.guid)!
}

fn (mut ar ActionRunner) job_result(mut job ActionJob) ! {
	ar.client.job_status_set(mut job, .done)!

	// add job to processor.result queue
	mut q_result := ar.client.redis.queue_get('jobs.processor.result')
	q_result.add(job.guid)!
}
