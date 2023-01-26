module processor

import time

import freeflowuniverse.baobab.jobs
import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.params

fn generate_jobs() ![]jobs.ActionJob {
	mut generated_jobs := []jobs.ActionJob{}
	actions := ['gitrunner.init', 'gitrunner.get', 'gitrunner.link', 'gitrunner.commit']
	for action in actions {
		generated_jobs << jobs.new(
			twinid: 0, 
			action: 'gitrunner.init')!
	}
	return generated_jobs
}

fn test_assign_job() {
	mut p := Processor{}
	generated_jobs := generate_jobs()!
	mut q_in := p.client.redis.queue_get('jobs.processor.in')
	mut guids := []string
	for job in generated_jobs {
		json_job := job.json_dump()
		p.client.redis.hset('jobs.db', job.guid, json_job)!
		q_in.add(job.guid)!
		p.assign_job(job.guid)!
		guids << job.guid
	}

	assert p.client.redis.rpop('jobs.actors.gitrunner.init')! in guids
	assert p.client.redis.rpop('jobs.actors.gitrunner.get')! in guids
	assert p.client.redis.rpop('jobs.actors.gitrunner.link')! in guids
	assert p.client.redis.rpop('jobs.actors.gitrunner.commit')! in guids

}

fn test_return_job() {
	mut p := Processor{}
	generated_jobs := generate_jobs()!
	mut q_result := p.client.redis.queue_get('jobs.processor.result')
	mut guids := []string
	for job in generated_jobs {
		json_job := job.json_dump()
		p.client.redis.hset('jobs.db', job.guid, json_job)!
		q_result.add(job.guid)!
		p.return_job(job.guid)!
		guids << job.guid
	}

	for guid in guids {
		popped_guid := p.client.redis.rpop('jobs.return.$guid')!
		assert typeof(popped_guid).name == 'string'
		assert popped_guid != ''
	}
}

fn test_run() {
	mut redis := redisclient.core_get()
	mut p := Processor{}
	mut q := &p
	job_error := jobs.new(
			twinid: 0, 
			action: 'domain.error')!

	job_result := jobs.new(
			twinid: 0, 
			action: 'domain.result')!

	redis.hset('jobs.db', job_error.guid, job_error.json_dump())!
	redis.hset('jobs.db', job_result.guid, job_result.json_dump())!

	h := spawn q.run()
	time.sleep(5000000)
	println("Slept")

	assert redis.rpop('jobs.actors.domain.error')! == job_error.guid
	assert redis.rpop('jobs.actors.domain.result')! == job_result.guid

	mut q_result := redis.queue_get('jobs.processor.result')
	mut q_error := redis.queue_get('jobs.processor.error')

	q_result.add(job_result.guid)!
	q_error.add(job_error.guid)!

	time.sleep(5000000)
	println("Slept")

	assert redis.rpop('jobs.return.$job_result')! == job_result.guid
	assert redis.rpop('jobs.return.$job_error')! == job_error.guid
	h.wait()!
}
