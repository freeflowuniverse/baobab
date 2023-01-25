module processor

import freeflowuniverse.baobab.jobs
import freeflowuniverse.crystallib.redisclient

fn generate_jobs() []ActionJob {
	mut jobs := []ActionJob{}
	jobs << jobs.new(0, 'gitrunner.init')
	jobs << jobs.new(0, 'gitrunner.get')
	jobs << jobs.new(0, 'gitrunner.link')
	jobs << jobs.new(0, 'gitrunner.commit')
	return jobs
}

// // TODO
// fn test_validate_job() {
// 	redis := redisclient.core_get()
// 	jobs := generate_jobs()
// 	q_in := redis.queue_get('processor.in')
// 	for job in jobs {
// 		q_in.add(job.guid)
// 	}
// 	for job in jobs {
// 		guid_in := q_in.redis.rpop(q_in.key)!
// 		assert validate_job(guid_in) != IError
// 	}
// }


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
	for {

	}
	redis.hset(jobs.db, )
}
