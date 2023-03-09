module processor

import freeflowuniverse.baobab.jobs
import freeflowuniverse.crystallib.redisclient

import encoding.base64
import json
import log
import os
import rand

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
	mut msg := RMBMessage {
		dat: base64.encode_str(job.json_dump())
		ret: rand.uuid_v4()
	}
	test_cases << RMBTestCase {
		job: job
		actor_queue: 'jobs.actors.crystallib.git'
		return_queue: msg.ret
		rmb_msg: msg
	}

	return test_cases
}

fn test_get_rmb_job() ! {
	logger := log.Log{
		level: .debug
	}
	mut p := new("localhost:6379", &logger)!
	cases := generate_test_cases() or { panic('Failed to generate test cases: $err') }
	mut q_rmb := p.client.redis.queue_get('msgbus.execute_job')
	for case in cases {
		encoded := json.encode(case.rmb_msg)
		q_rmb.add(encoded) or { panic('Failed to add: $err') }
		job_guid := p.get_rmb_job() or { '' }
		assert job_guid == case.job.guid
		assert p.client.redis.hexists('jobs.db', job_guid) or { panic('Failed to run hexists $err') }
	}
}

fn test_return_job_rmb() {
	logger := log.Log{
		level: .debug
	}
	mut p := new("localhost:6379", &logger)!
	mut redis := redisclient.core_get()
	test_cases := generate_test_cases() or { panic('Failed to add to queue $err') }
	mut q_result := p.client.redis.queue_get('jobs.processor.result')

	// assert returns job to expected return queue
	for case in test_cases {
		p.client.redis.hset('jobs.db', case.job.guid, case.job.json_dump()) or { panic('Failed to run hset $err') }
		p.client.redis.hset('rmb.db', case.job.guid, json.encode(case.rmb_msg)) or { panic('Failed to run hset $err') }
		q_result.add(case.job.guid) or { panic('Failed to add to queue $err') }
		p.return_job_rmb(case.job.guid) or { panic('Failed to add to queue $err') }
		returned_msg := redis.rpop(case.return_queue) or { panic('Failed to add to queue $err') }
		rmb_response := json.decode(RMBResponse, returned_msg)!
		job := json.decode(jobs.ActionJob, base64.decode_str(rmb_response.dat))!
		assert job.guid == case.job.guid
	}
}
