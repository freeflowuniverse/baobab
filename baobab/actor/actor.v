module actor

import freeflowuniverse.baobab.jobs

pub interface IActor {
	name string
mut:
    execute(mut job jobs.ActionJob)!
}