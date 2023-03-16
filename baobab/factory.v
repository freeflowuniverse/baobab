module baobab

import client

pub struct BaoBab {
pub mut:
	client client.Client
}

pub fn new(redis_address string) !BaoBab {
	return BaoBab {
		client: client.new(redis_address)!
	}
}
