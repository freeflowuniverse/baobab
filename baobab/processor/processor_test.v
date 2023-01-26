module processor

import time

import freeflowuniverse.baobab.baobab.jobs
import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.params

fn testsuite_begin() {
	mut redis := redisclient.core_get()
	redis.flushall()!
	redis.disconnect()
}

fn generate_jobs() ![]jobs.ActionJob {
	mut generated_jobs := []jobs.ActionJob{}
	actions := ['crystallib.gitrunner.init', 'crystallib.gitrunner.get', 'crystallib.gitrunner.link', 'crystallib.gitrunner.commit']
	for action in actions {
		generated_jobs << jobs.new(
			twinid: 0, 
			action: action)!
	}
	return generated_jobs
}

// fn test_assign_job() {
// 	mut redis := redisclient.core_get()
// 	mut p := Processor{}
// 	generated_jobs := generate_jobs()!
// 	mut q_in := redis.queue_get('jobs.processor.in')
// 	mut guids := []string
// 	for job in generated_jobs {
// 		json_job := job.json_dump()
// 		redis.hset('jobs.db', job.guid, json_job)!
// 		q_in.add(job.guid)!
// 		p.assign_job(job.guid)!
// 		guids << job.guid
// 	}

// 	assert redis.rpop('jobs.actors.crystallib.gitrunner')! in guids
// 	assert redis.rpop('jobs.actors.crystallib.gitrunner')! in guids
// 	assert redis.rpop('jobs.actors.crystallib.gitrunner')! in guids
// 	assert redis.rpop('jobs.actors.crystallib.gitrunner')! in guids

// // }

// fn test_return_job() {
// 	mut p := Processor{}
// 	generated_jobs := generate_jobs()!
// 	mut q_result := p.client.redis.queue_get('jobs.processor.result')
// 	mut guids := []string
// 	for job in generated_jobs {
// 		json_job := job.json_dump()
// 		p.client.redis.hset('jobs.db', job.guid, json_job)!
// 		q_result.add(job.guid)!
// 		p.return_job(job.guid)!
// 		guids << job.guid
// 	}

// 	for guid in guids {
// 		popped_guid := p.client.redis.rpop('jobs.return.$guid')!
// 		assert typeof(popped_guid).name == 'string'
// 		assert popped_guid != ''
// 	}
// }

fn test_run() {
	mut redis := redisclient.core_get()
	mut p := Processor{}
	mut q := &p
	job := jobs.new(
			twinid: 0, 
			action: 'crystallib.gitrunner.init')!

	redis.hset('jobs.db', job.guid, job.json_dump())!
	mut r_in := redis.queue_get('jobs.processor.in')
	r_in.add(job.guid)!

	spawn q.run()
	time.sleep(5000000)

	mock_actor()!

	time.sleep(5000000)

	assert redis.rpop('jobs.return.$job.guid')! == job.guid
}


fn mock_actor () ! {
	mut redis := redisclient.core_get()
	mut q_gitrunner := redis.queue_get('jobs.actors.crystallib.gitrunner')
	guid := q_gitrunner.get(100)!
	mut q_result := redis.queue_get('jobs.processor.result')
	q_result.add(guid)!
}