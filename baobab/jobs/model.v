module jobs

import freeflowuniverse.crystallib.params { Params }
import time

pub enum ActionJobState {
	init
	tostart
	recurring
	scheduled
	active
	done
	error
}

pub struct ActionJobs {
pub mut:
	jobs []ActionJob
}

pub struct ActionJob {
pub mut:
	guid         string // unique jobid (unique per actor which is unique per twin)
	twinid       u32    // which twin needs to execute the action
	action       string // actionname in long form includes domain & actor $domain.$actor.$action
	args         Params
	result       Params
	state        ActionJobState
	start        time.Time
	end          time.Time
	grace_period u32 // wait till next run
	error        string
	timeout      u32    // time in seconds, 2h is maximum
	src_twinid   u32    // which twin is responsible for executing on behalf of actor
	src_action   string // unique actor id, runs on top of twin
	dependencies []string
}

pub struct JobError {
	Error
pub mut:
	msg      string
	job_guid string
}

pub fn (err JobError) msg() string {
	return 'Job Error: Job ${err.job_guid} failed with error: ${err.msg}'
}
