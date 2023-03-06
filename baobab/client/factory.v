module client

// import freeflowuniverse.baobab.jobs { ActionJob, ActionJobState, JobNewArgs, new, json_load }
import freeflowuniverse.crystallib.redisclient
// import freeflowuniverse.crystallib.params { Params }
// import rand
// import time

pub struct Client {
pub mut:
	redis  redisclient.Redis
	twinid u32
}

pub fn new(redis_address string) !Client {
	mut redis := redisclient.get(redis_address)!
	mut client := Client {
		redis: redis
	}
	twinid := client.redis.get('client.mytwin.id') or { '0' }
	client.twinid = twinid.u32()
	return client
}
