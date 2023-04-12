module utils

import rand

pub fn random_id() string {
	set := '0123456789abcdefghijklmnopqrstuvwxyz'
	return rand.string_from_set(set, 3)
}