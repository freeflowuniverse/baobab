module processor

struct RMBMessage {
	mut:
	version u64 [json: ver]
	reference string [json: ref]
	source string [json: src]
	command string [json: cmd]
	expiration u64 [json: exp]
	data string [json: dat]
	tags string [json: tag]
	reply_to string [json: ret]
	schema string [json: shm]
	timestamp u64 [json: now]
}