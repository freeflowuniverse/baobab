module people

import freeflowuniverse.baobab.utils

// Data Struct, DB in memory, over time will be cut in pieces and prob moved to more actor paradigm but ok for now
[heap]
pub struct PeopleDB {
pub:
	bid    string   // id of the book
	filter []string // how to sort & filter
	actor  string
pub mut:
	persons []Person
	contact []Contact
	circles []Circle
}

// creates a new book data structure
pub fn db(bid string) PeopleDB {
	mut d := PeopleDB{
		// TODO: does this work for people.circle_delete... as well?
		filter: ['circle_delete', 'person_delete', 'circle_define', 'person_define', 'circle_link',
			'circle_comment', 'digital_payment_add']
		actor: 'people'
		bid: bid
	}
	return d
}

// todo: implement logic
pub fn (db PeopleDB)cid_new() string {
	for {
		mut cid := utils.random_id()
		if db.persons.any(it.cid == cid) {
			continue
		}
		// if db.contact.any(it.cid == cid) {
		// 	continue
		// }
		if db.circles.any(it.cid == cid) {
			continue
		}
		return cid
	}
	return '' // todo: handle error
}

pub fn (db PeopleDB) get(cid string) ?&Person {
	person := db.persons.filter(it.cid == cid)
	if person.len == 1 {
		return &person[0]
	}
	return none
}

pub fn (db PeopleDB) get_circle(cid string) ?&Circle {
	circles := db.circles.filter(it.cid == cid)
	if circles.len == 1 {
		return &circles[0]
	}
	return none
}