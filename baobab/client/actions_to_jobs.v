module client

import os
import freeflowuniverse.baobab.baobab.actions
import freeflowuniverse.baobab.baobab.jobs
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

		//TODO: set as dependencie the previous one done
		
		// call client to schedule the job
		client.job_schedule(job) or {panic('Failed to schedule: $err')}

	}
	return jobsfactory
}