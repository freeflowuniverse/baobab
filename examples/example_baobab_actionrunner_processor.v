module main

import freeflowuniverse.baobab
import freeflowuniverse.baobab.actions
import freeflowuniverse.baobab.actionrunner
import freeflowuniverse.baobab.client
import freeflowuniverse.baobab.jobs
import freeflowuniverse.baobab.processor

import log
import os


// Should implement IActor 
pub struct MyActor {
	name string = "threefold.books"
}
fn (mut ma MyActor) execute(mut job jobs.ActionJob)! {
	// Check if the job is meant for us and parse arguments
	// Do some work based on the job
	println("Executing job ${job.action} with params ${job.args}")
}


fn main() {
	do() or { 
		eprintln(err)
		exit(1)
	}
}

fn do() ! {
	redis_address := "localhost:6379"
	mut client_ := client.new(redis_address)!
	mut myactor := MyActor {}
	mut ar := actionrunner.new(client_, [&myactor])
	logger := log.Log {
		level: .debug
	}
	mut processor_ := processor.new(redis_address, &logger)!

	// concurrently run actionrunner, processor, and external client
	spawn (&ar).run()
	spawn (&processor_).run()
	spawn run_external_client()

	for {}
}

fn run_external_client() ! {
	mut client_ := client.new("localhost:6379")!
	// get actions manager from dir with action files
	actions_path := os.dir(@FILE) + '/actionsdir'
	mut actionsmgr := actions.dir_parse(actions_path)!

	// call schedule actions to feed actions to processor
	actionjobs := client_.schedule_actions(actions: actionsmgr.actions)!

	for job in actionjobs.jobs {
		job_complete := client_.job_wait(job.guid, 60)!
		println('Retrieved job: ${job_complete}')
	}
}
