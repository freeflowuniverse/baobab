module client

import freeflowuniverse.baobab.jobs { ActionJob, ActionJobState, JobNewArgs,json_load }
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
	client.job_schedule_wait(mut job, 0)! //? should this be the job timeout or a custom timeout
	return job
}

// schedules the job to be executed
pub fn (mut client Client) job_schedule(mut job ActionJob) ! {
	job.state = .tostart
	client.job_set(job)!
	client.redis.lpush('jobs.processor.in', '${job.guid}')!
	// now := time.now().unix_time()
	// client.redis.hset('jobs.processor.out', '${job.guid}', '${now}')!
}


// get the job back from redis
pub fn (mut client Client) job_get(guid string) !ActionJob {
	data := client.redis.hget('jobs.db', '${guid}') or {
		return error('Cannot find job: ${guid}.\n${err}')
	}
	mut job := json_load(data)!
	return job
}

// get the job from the local redis
pub fn (mut client Client) job_set(job ActionJob) ! {
	data := job.json_dump()
	client.redis.hset('jobs.db', '${job.guid}', data)!
}

// remove the job from the local redis
pub fn (mut client Client) job_delete(guid string) ! {
	client.redis.hdel('jobs.db', '${guid}')!
}

// updates the status of a job in jobs.db
pub fn (mut client Client) job_status_set (mut job ActionJob, state ActionJobState)!{
	job.state = state
	client.job_set(job)!
}

// check if the job is ready to be retrieved (can be error, or ok)
//if return = true it means there is a job so we can retrieve it
pub fn (mut client Client) job_check_ready(guid string) !bool {
	key:='jobs.return.${guid}'
	ll:=client.redis.llen(key)!
	if ll>0{
		return true
	}
	return false
}

//check if the job is ready to be retrieved (can be error, or ok)
//if yes will return the Job
//timout 0, means we will wait for 1h
pub fn (mut client Client) job_wait(guid string,timeout_ int) !ActionJob {
	mut timeout:=timeout_
	if timeout==0{
		timeout=3600
	}
	key:='jobs.return.${guid}'
	client.redis.brpop(key,timeout)! //will block and wait
	return client.job_get(guid)!
}



// schedules the job to be executed and then wait on return
pub fn (mut client Client) job_schedule_wait(mut job ActionJob,timeout int) !ActionJob {
	client.job_schedule(mut job)!
	return client.job_wait(job.guid,timeout)!
}

pub fn (mut client Client) reset() ! {
	client.redis.del('jobs.db')!
	// client.redis.del('jobs.out')!
	// client.redis.del('jobs.in')!
	client.redis.del('client.iam')!
	// client.redis.del('client.twins.max_twin_id')!
	// client.redis.del('jobs.queue.out')!
	// client.redis.del('jobs.queue.in')!

	// need to save the info we still have in mem to redis
	client.redis.set('client.mytwin.id', client.twinid.str())!
	// for k, v in client.actor_coordinates {
	// 	client.redis.hset('client.actorcoordinates', k, v)!
	// }
}
