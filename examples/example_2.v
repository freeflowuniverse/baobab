module main

import freeflowuniverse.baobab
import freeflowuniverse.baobab.actionparser
import freeflowuniverse.baobab.actionrunner
import freeflowuniverse.baobab.client
import freeflowuniverse.baobab.jobs


fn main() {

	mut b := baobab.new()

	ar := actionrunner.new(b.client)
	ar := actionrunner.new(b.client)

	spawn ar.run()
	spawn processor.run()
	spawn run_external()

}

fn run_external() {

	// single action example:
	// client gets

	// get actions manager from dir with action files
	actions_path := os.dir(@FILE) + '/actionsdir'
	mut actionsmgr := actions.dir_parse(actions_path)!

	// 
	b.client.schedule_actions(actions:actionsmgr.actions)
}