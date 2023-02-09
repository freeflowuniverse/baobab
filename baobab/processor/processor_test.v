module processor

import freeflowuniverse.baobab.jobs
import json
import os
import freeflowuniverse.crystallib.redisclient
import time

struct TestCase {
	job          jobs.ActionJob // job
	actor_queue  string // correct actor queue for job
	return_queue string // correct return queue for job
	error_msg    string // correct error message for job
}

// reset redis on test begin and run servers
fn testsuite_begin() {
	os.execute('redis-server --daemonize yes &')
	mut redis := redisclient.core_get()
	redis.flushall()!
	redis.disconnect()
}

// creates mock test jobs with hardcoded expected outcomes
fn generate_test_cases() ![]TestCase {
	mut redis := redisclient.core_get()
	mut test_cases := []TestCase{}

	// job for git actor in crystallib
	mut job := jobs.new(action: 'crystallib.git.init')!
	redis.hset('jobs.db', job.guid, job.json_dump())!
	test_cases << TestCase{
		job: job
		actor_queue: 'jobs.actors.crystallib.git'
		return_queue: 'jobs.return.${job.guid}'
	}

	// job for another function in git actor in crystallib
	job = jobs.new(action: 'crystallib.git.get')!
	redis.hset('jobs.db', job.guid, job.json_dump())!
	test_cases << TestCase{
		job: job
		actor_queue: 'jobs.actors.crystallib.git'
		return_queue: 'jobs.return.${job.guid}'
	}

	// job for books actor in crystallib
	job = jobs.new(action: 'crystallib.books.init')!
	redis.hset('jobs.db', job.guid, job.json_dump())!
	test_cases << TestCase{
		job: job
		actor_queue: 'jobs.actors.crystallib.books'
		return_queue: 'jobs.return.${job.guid}'
	}

	//? should the processor check if a queue exists beforehand or not
	// job for unexisting domain
	job = jobs.new(action: 'somedomain.actor.action')!
	redis.hset('jobs.db', job.guid, job.json_dump())!
	test_cases << TestCase{
		job: job
		actor_queue: 'jobs.actors.somedomain.actor'
		return_queue: 'jobs.return.${job.guid}'
	}

	return test_cases
}

// tests if the processor places jobs in correct jobs.domain.actor queue
fn test_assign_job() {
	mut redis := redisclient.core_get()
	mut p := Processor{}
	test_cases := generate_test_cases() or { panic('Failed to generate test cases: ${err}') }

	// test assigns job to expected domain.actor queue & active queue
	for case in test_cases {
		p.assign_job(case.job.guid) or { panic('Failed to assign job: ${err}') }
		assert redis.rpop(case.actor_queue)! == case.job.guid
		assert redis.rpop('jobs.processor.active')! == case.job.guid
	}
}

// tests if the processor places jobs in correct jobs.return queue
fn test_return_job() {
	mut redis := redisclient.core_get()
	mut p := Processor{}
	test_cases := generate_test_cases()!
	mut q_result := p.client.redis.queue_get('jobs.processor.result')
	mut guids := []string{}

	// assert returns job to expected return queue
	for case in test_cases {
		q_result.add(case.job.guid)!
		p.return_job(case.job.guid)!
		assert redis.rpop(case.return_queue)! == case.job.guid
	}
}

fn test_reset() ! {
	// assert val exists before reset
	mut p := Processor{}
	p.client.redis.hset('reset_test', 'key', 'data')!
	assert p.client.redis.hexists('reset_test', 'key')!

	// assert val doesn't exist after reset
	p.reset() or { panic('Failed to reset ${err}') }
	assert !p.client.redis.hexists('reset_test', 'key')!
}

// tests if processor assigns jobs to actors and returns results/errors
fn test_run() {
	mut redis := redisclient.core_get()
	mut p := Processor{}
	test_cases := generate_test_cases()!
	spawn (&p).run() // run processor concurrently

	// feed processor.in queue with test jobs
	mut q_in := redis.queue_get('jobs.processor.in')
	for case in test_cases {
		q_in.add(case.job.guid)!
	}

	time.sleep(50000000) // wait processor work

	// feed processor.error/result queue with test jobs, mocking actor
	mut q_error := redis.queue_get('jobs.processor.error')
	mut q_result := redis.queue_get('jobs.processor.result')
	for case in test_cases {
		guid := redis.rpop(case.actor_queue)!
		q_result.add(guid)!
	}

	time.sleep(50000000) // wait processor work

	// assert all jobs.processor queues are empty
	assert redis.llen('jobs.processor.in')! == 0
	assert redis.llen('jobs.processor.error')! == 0
	assert redis.llen('jobs.processor.result')! == 0

	// assert all jobs are returned correctly
	for case in test_cases {
		guid := redis.rpop(case.return_queue)!
		assert guid == case.job.guid
	}
}
