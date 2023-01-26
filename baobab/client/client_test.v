module client

import os
import freeflowuniverse.crystallib.texttools
import freeflowuniverse.baobab.baobab.actions

const testpath = os.dir(@FILE) + '/../testdata'


fn test_get_jobs() {
	
	mut cl:=new() or {panic("can't get client")}

	mut actionsmgr:=actions.dir_parse(testpath)!
	assert actionsmgr.actions.len == 11

	mut j:=cl.schedule_actions(actions:actionsmgr.actions)
	assert j.jobs.last().action=="books.mdbook_develop"

	

}
