module client

import os
import freeflowuniverse.baobab.actions
import freeflowuniverse.baobab.jobs
import time
import rand

[params]
pub struct ScheduleActionsArgs{
	twinid u32
	src_twinid u32
	src_action string
	timeout u32
	actions []actions.Action
}


//returns a collection of jobs
pub fn (mut client Client) schedule_actions(args ScheduleActionsArgs) jobs.ActionJobs {
	mut jobsfactory:=jobs.ActionJobs{}
	for a in args.actions{
		mut job := jobs.ActionJob {
			guid:rand.uuid_v4()
			twinid:args.twinid
			action:a.name
			args:a.params
			// result
			start:time.now()
			// end
			// grace_period
			// error
			timeout:args.timeout
			src_twinid:args.src_twinid
			src_action:args.src_action
			// dependencies
		}
		jobsfactory.jobs << job
	}
	return jobsfactory
}