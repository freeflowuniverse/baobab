module main

import freeflowuniverse.baobab
import freeflowuniverse.baobab.actions
import freeflowuniverse.baobab.actor
import freeflowuniverse.baobab.actionrunner
import freeflowuniverse.baobab.client
import freeflowuniverse.baobab.gitactor
import freeflowuniverse.baobab.jobs
import freeflowuniverse.baobab.processor
import os

fn main() {
	do() or { panic(err) }
}

fn do() ! {
	// create baobab, actionrunner and processor
	mut b := baobab.new()!
	mut gitactor := gitactor.GitActor{}
	mut ar := actionrunner.new(b.client, [&actor.IActor(gitactor)])!
	mut processor := processor.Processor{}

	// concurrently run actionrunner, processor, and external client
	spawn (&ar).run()
	spawn (&processor).run()
	spawn run_external_client()

	for {}
}

fn run_external_client() {
	mut b := baobab.new() or { panic(err) }
	// get actions manager from dir with action files
	actions_path := os.dir(@FILE) + '/actionsdir'
	mut actionsmgr := actions.dir_parse(actions_path) or { panic(err) }

	// call schedule actions to feed actions to processor
	actionjobs := b.client.schedule_actions(actions: actionsmgr.actions)

	//
	for job in actionjobs.jobs {
		job_complete := b.client.job_wait(job.guid, 60) or { panic(err) }
		println('Retrieved job: ${job_complete}')
	}
}




