module client

import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.actionsparser
import os

const samples_dir = os.dir(@FILE) + '/../../examples/actionsdir'

// reset redis on test begin and run servers
fn testsuite_begin() {
	mut redis := redisclient.core_get()
	redis.flushall()!
	redis.disconnect()
}

// reset redis on test end
fn testsuite_end() {
	mut redis := redisclient.core_get()
	redis.flushall()!
	redis.disconnect()
}

fn test_get_jobs() {
	mut cl := new('localhost:6379')!

	mut parser := actionsparser.new(
		path: client.samples_dir
	)!
	assert parser.actions.len == 11

	mut j := cl.schedule_actions(actions: parser.actions)!
	assert j.jobs.last().action == 'mdbook_develop'
}
