module processor

import freeflowuniverse.baobab.baobab.jobs
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
	p := Processor{}
	generated_jobs := generate_jobs()
	q_in := p.redis.queue_get('processor.in')
	guids := []string
	for job in generated_jobs {
		json_job := job.json_dump()
		p.redis.hset('jobs.db', job.guid, json_job)
		q_in.add(job.guid)
		p.assign_job(job.guid)
		guids << job.guid
	}

	assert p.redis.rpop('gitrunner.init')! in guids
	assert p.redis.rpop('gitrunner.get')! in guids
	assert p.redis.rpop('gitrunner.link')! in guids
	assert p.redis.rpop('gitrunner.commit')! in guids

}

fn test_return_job() {
	p := Processor{}
	generated_jobs := generate_jobs()
	q_result := p.redis.queue_get('processor.result')
	guids := []string
	for job in generated_jobs {
		json_job := job.json_dump()
		p.redis.hset('jobs.db', job.guid, json_job)
		q_result.add(job.guid)
		p.return_job(job.guid)
		guids << job.guid
	}

	for guid in guids {
		popped_guid := p.redis.rpop('jobs.return.$guid')!
		assert typeof(popped_guid).name == string
		assert popped_guid != ''
	}
}

fn test_run() {
	redis := redisclient.core_get()
	mut p := Processor{}
	
	p.run()!


}
