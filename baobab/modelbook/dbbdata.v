module modelbook

import freeflowuniverse.baobab.modelbook.people
import freeflowuniverse.baobab.modelbook.company
import time

// Data Struct, DB in memory, over time will be cut in pieces and prob moved to more actor paradigm but ok for now
[heap]
pub struct DBBData {
pub mut:
	people    map[string]&people.Person
	contact   map[string]&people.Contact
	companies map[string]&company.Company
	circles   map[string]&people.Circle
}

// creates a new book data structure
pub fn new() DBBData {
	mut d := DBBData{}
	return d
}
