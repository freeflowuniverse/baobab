module client

import time
import os
import freeflowuniverse.crystallib.texttools
import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.baobab.actions

const samples_dir = os.dir(@FILE) + '/../../examples/actionsdir'

// reset redis on test begin and run servers
fn testsuite_begin() {
	os.execute('redis-server --daemonize yes &')
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
	mut cl := new() or { panic("can't get client") }

	mut actionsmgr := actions.dir_parse(client.samples_dir)!
	assert actionsmgr.actions.len == 11

	mut j := cl.schedule_actions(actions: actionsmgr.actions)
	assert j.jobs.last().action == 'books.mdbook_develop'
}
