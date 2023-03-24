module utils

pub fn test_random_id() {
	id := random_id()
	println(id)
	assert id.len == 3
}