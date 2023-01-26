module actionrunner

import freeflowuniverse.crystallib.gittools { GitStructure }
import freeflowuniverse.baobab.client { Client }
import freeflowuniverse.baobab.jobs { ActionJob }
import freeflowuniverse.baobab.gitactor

// Actionrunner listens to jobs in an actors queue
// executes the jobs internally
// sets the status of the job in jobs.db in the process
// then moves jobs into processor.error/result queues
pub struct ActionRunner {
pub mut:
	gs     &GitStructure
	client &Client
}

// factory function for actionrunner
pub fn new(client Client) !ActionRunner {
	mut gs := gittools.get(root: '')!
	mut ar := ActionRunner{
		gs: &gs
		client: &client
	}
	return ar
}

pub fn (mut ar ActionRunner) run() {
	// job queue for git actor
	mut q_git := ar.client.redis.queue_get('jobs.actors.crystallib.git')

	// go over  jobs.actors in redis, see which jobs we have pass them onto the execute
	for {
		// get guid in queue, move on if nil
		job_guid := q_git.pop() or {''}
		if job_guid == '' {
			continue
		}

		// get job, set job active and execute
		mut job := ar.client.job_get(job_guid) or {panic(err)}
		ar.execute(mut job) or {panic(err)}
		// todo: timeout check
	}
}

// execute calls execute_internal and handles error/result
pub fn (mut ar ActionRunner) execute(mut job ActionJob) ! {
	$if debug {
		eprintln('Executing job: $job.guid')
	}

	ar.execute_internal(mut job) or {
		// means there was error
		ar.job_error(mut job, err.msg)!
	}
	ar.job_result(mut job)! // job was succesful
}

// execute_internal matches job with actor, and calls actor.execute to execute job
fn (mut ar ActionRunner) execute_internal(mut job ActionJob) ! {
	if job.action.starts_with('crystallib.git') {
		ar.client.job_status_set(mut job, .active)!
		gitactor.execute(mut ar.gs, mut job)!
	}
	return error('could not find actor to execute on the job')
}

fn (mut ar ActionRunner) job_error(mut job ActionJob, errmsg string) ! {
	job.error = errmsg
	ar.client.job_status_set(mut job, .error)!

	// add job to processor.error queue
	mut q_error := ar.client.redis.queue_get('processor.error')
	q_error.add(job.guid)!
}

fn (mut ar ActionRunner) job_result(mut job ActionJob) ! {
	ar.client.job_status_set(mut job, .done)!

	// add job to processor.result queue
	mut q_result := ar.client.redis.queue_get('processor.result')
	q_result.add(job.guid)!
}
