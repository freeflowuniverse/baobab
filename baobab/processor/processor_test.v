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

fn test_assign_job() {
	redis := redisclient.core_get()
	jobs := generate_jobs()
	for job in jobs {
		redis.hset(jobs.db, )
	}
	redis.hset(jobs.db, )
}

fn test_run() {
	redis := redisclient.core_get()
	for {

	}
	redis.hset(jobs.db, )
}
