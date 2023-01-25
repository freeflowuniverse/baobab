module actionrunner
import freeflowuniverse.crystallib.gittools {GitStructure}
import freeflowuniverse.baobab.client { Client }
import freeflowuniverse.baobab.jobs { ActionJob }
import freeflowuniverse.baobab.gitactions

pub struct ActionRunner{
pub mut:
	gs &GitStructure
	client &Client
}

fn new(client Client)!ActionRunner{
	mut gs := gittools.get(root: '')!
	mut ar:=ActionRunner{
		gs: &gs
		client: &client
		}
	return ar
}


pub fn (mut ar ActionRunner) run()!{

	// job queue for git actor
	q_git := ar.client.redis.queue_get('jobs.actors.crystallib.git')
	
	for {
		// get guid in queue, move on if nil
		job_guid := q_git.redis.rpop(q_git.key)
		if job_guid == '' { continue } 

		// get job from guid and execute
		job := ar.client.job_get(job_guid)
		ar.execute(job)

		// ret
		//todo: listen to redis 
		//todo: pass action to execute
		//todo: timeout check
	}
	//go over  jobs.actors in redis, see which jobs we have pass them onto the execute
	//is a loop

}



pub fn (mut ar ActionRunner) execute (mut job ActionJob)!{

	ar.execute_internal(job) or {
		//means there was error
		ar.job_error_set(job,err)
	}
	ar.job_status_set(job,.ok) //job was succesful

}

fn (mut ar ActionRunner) execute_internal (mut job ActionJob)!{

	if job.action.starts_with("crystallib.git"){
		ar.job_status_set(job,.active)
		return gitactions.execute(mut ar.gs,mut job)!
	}
	return error("could not find actor to execute on the job")

}


//
fn (mut ar ActionRunner) job_status_set (mut job ActionJob,state ActionJobState)!{
	// save the job using the client on ar, will bring it to redis
	job.state = state
	ar.client.job_set(job)
}

fn (mut ar ActionRunner) job_error_set (mut job ActionJob, errmsg string)!{
	job.state = .error
	job.error = errmsg
	ar.client.job_set(job)
	//TODO: now save the job using the client on ar, will bring it to redis, the job failed

}
