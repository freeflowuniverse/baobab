module people

import time

// Data Struct, DB in memory, over time will be cut in pieces and prob moved to more actor paradigm but ok for now
[heap]
pub struct DB {
pub:
	bid string // id of the book
pub mut:
	people  map[string]&people.Person
	contact map[string]&people.Contact
	circles map[string]&people.Circle
}

// creates a new book data structure
pub fn db(bid string) DB {
	mut d := DB{}
	return d
}
