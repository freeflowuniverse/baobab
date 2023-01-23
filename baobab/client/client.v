module client

import freeflowuniverse.baobab.jobs { ActionJob, ActionJobState, JobNewArgs, json_load }
import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.params { Params }
import rand
import time

pub fn (mut client Client) job_new(args JobNewArgs) !ActionJob {
	mut j:=jobs.new(args)!
	j.src_twinid=client.twinid
	return j
}

pub fn (mut client Client) job_new_schedule(args JobNewArgs) !ActionJob {
	mut job := client.job_new(args)!
	client.job_schedule(mut job)!
	return job
}

pub fn (mut client Client) job_new_wait(args JobNewArgs) !ActionJob {
	mut job := client.job_new(args)!
	client.job_schedule_wait(mut job)!
	return job
}

// schedules the job to be executed
pub fn (mut client Client) job_schedule(mut job ActionJob) ! {
	job.state = .tostart
	client.job_set(job)!
	client.redis.lpush('jobs.queue.out', '${job.guid}')!
	now := time.now().unix_time()
	client.redis.hset('client.jobs.out', '${job.guid}', '${now}')!
}


// get the job back from redis
pub fn (mut client Client) job_get(guid string) !ActionJob {
	data := client.redis.hget('client.jobs.db', '${guid}') or {
		return error('Cannot find job: ${guid}.\n${err}')
	}
	mut job := jobs.job_load(data)!
	return job
}

// store the job in the local redis
pub fn (mut client Client) job_set(job ActionJob) ! {
	data := job.json()
	client.redis.hset('client.jobs.db', '${job.guid}', data)!
}

pub fn (mut client Client) next_job_guid() !string {
	guid := client.redis.rpop('jobs.queue.out')!
	return guid
}

// put the job in the first queue of the first actor that matches the action of the job
pub fn (mut client Client) reschedule_to_actor(job ActionJob) ! {
	for actor, queue in client.actor_coordinates {
		if job.action.starts_with(actor) {
			client.redis.lpush(queue, '${job.guid}')!
			now := time.now().unix_time()
			client.redis.hset('client.jobs.in', '${job.guid}', '${now}')!
		}
	}
}

// schedules the job to be executed and then wait on return
pub fn (mut client Client) job_schedule_wait(mut job ActionJob) ! {
	client.job_schedule(mut job)!
}

pub fn (mut client Client) reset() ! {
	client.redis.del('client.jobs.db')!
	client.redis.del('client.jobs.out')!
	client.redis.del('client.jobs.in')!
	client.redis.del('client.iam')!
	client.redis.del('client.twins.max_twin_id')!
	client.redis.del('jobs.queue.out')!
	client.redis.del('jobs.queue.in')!

	// need to save the info we still have in mem to redis
	client.redis.set('client.mytwin.id', client.twinid.str())!
	for k, v in client.actor_coordinates {
		client.redis.hset('client.actorcoordinates', k, v)!
	}
}
