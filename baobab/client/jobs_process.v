module client

fn action_get_key(action_ string) !string {
	mut action := action_.trim('.').trim_space().trim('.').to_lower()
	items := action.split('.')
	if items.len < 2 {
		return error('actor specification need to be domain.actor')
	}
	key := 'jobs.actors.${items[0]}.${items[1]}'
	return key
}

// see if there is anything for me to do (this is me executing on RPC)
// action is specified as $domain.$actor.$actionname
// returns the guid of the job
// use timeout if we need to wait (blocking), if timeout=0, then we won't wait
pub fn (mut client Client) check_job_process(action string, timeout int) !string {
	key := action_get_key(action)!
	if timeout > 0 {
		res := client.redis.brpop([key], timeout)!
		return res[1]
	} else {
		return client.redis.rpop(key)!
	}
	return ''
}

pub fn (mut client Client) check_remaining_jobs(actor string) !int {
	return client.redis.llen('jobs.actors.${actor}')!
}
