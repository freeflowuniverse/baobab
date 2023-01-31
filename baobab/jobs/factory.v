module jobs

import freeflowuniverse.crystallib.params { Params }
import rand
import time

[params]
pub struct JobNewArgs {
pub mut:
	twinid       u32
	action       string
	args         Params
	actionsource string
}

// creates new actionjob
pub fn new(args JobNewArgs) !ActionJob {
	mut j := ActionJob{
		guid: rand.uuid_v4()
		twinid: args.twinid
		action: args.action
		args: args.args
		start: time.now()
		src_action: args.actionsource
		src_twinid: 0
	}
	return j
}
