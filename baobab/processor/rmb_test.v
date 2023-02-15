module processor

import freeflowuniverse.baobab.jobs
import json
import os
import freeflowuniverse.crystallib.redisclient
import time

struct RMBTestCase {
	job          jobs.ActionJob // job
	actor_queue  string     // correct actor queue for job
	return_queue string     // correct return queue for job
	error_msg    string     // correct error message for job
	rmb_msg      RMBMessage // RMB message carrying job over msgbus
}

// reset redis on test begin and run servers
fn testsuite_begin() {
	os.execute('redis-server --daemonize yes &')
	mut redis := redisclient.core_get()
	redis.flushall()!
	redis.disconnect()
}

// creates mock test rmb messages with hardcoded expected outcomes
fn generate_test_cases() ![]RMBTestCase {
	mut test_cases := []RMBTestCase{}

	// RMBMessage with job payload
	job := jobs.new(action: 'crystallib.git.init')!
	mut msg := RMBMessage{
		data: job.json_dump()
	}
	test_cases << RMBTestCase{
		job: job
		actor_queue: 'jobs.actors.crystallib.git'
		return_queue: 'msgbus.system.reply'
		rmb_msg: msg
	}

	return test_cases
}

fn test_get_rmb_job() ! {
	mut p := Processor{}
	cases := generate_test_cases()!
	mut q_rmb := p.client.redis.queue_get('msgbus.execute_job')
	for case in cases {
		q_rmb.add(json.encode(case.rmb_msg))!
		job_guid := p.get_rmb_job() or { '' }
		assert job_guid == case.job.guid
		assert p.client.redis.hexists('jobs.db', job_guid)!
	}
}

fn test_return_job_rmb() {
	mut p := Processor{}
	mut redis := redisclient.core_get()
	test_cases := generate_test_cases()!
	mut q_result := p.client.redis.queue_get('jobs.processor.result')

	// assert returns job to expected return queue
	for case in test_cases {
		p.client.redis.hset('jobs.db', case.job.guid, case.job.json_dump())!
		p.client.redis.hset('rmb.db', case.job.guid, json.encode(case.rmb_msg))!
		q_result.add(case.job.guid)!
		p.return_job_rmb(case.job.guid)!
		returned_msg := redis.rpop(case.return_queue)!
		assert returned_msg.contains(case.job.guid)
	}
}