module baobab

import client

pub struct BaoBab{
pub mut:
	client client.Client
}

pub fn new(){
	return BaoBab{
		client: client.new()
	}
}