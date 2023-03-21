module people

import freeflowuniverse.baobab.modelbase
import time

[heap]
pub struct Person {
	modelbase.Base
pub mut:
	description string    // description of the link to the person as contact
	start_date  time.Time // if we make link to person into our own book, we can have start/end date
	end_date    time.Time
	contact     &Contact // this has the effective information to the person = contact
	// paymentmethods 	[]finance.PaymentMethod	
	// person_type PersonType
}

pub fn (mut o Person) wiki() !string {
	// TODO: fill in template
	return $tmpl('templates/person.md')
}

// create a new instance of a person, can be changed after instantiation
pub fn (mut db PeopleDB) person_new(mut contact Contact) !&Person {
	mut p := Person{
		cid: db.cid_new()
		contact: contact
	}
	db.persons << p
	return &db.persons.last()
}

// delete person
pub fn (mut db PeopleDB) person_delete(cid_ string) ! {
	cid := cid_.to_lower()
	// TODO: delete from list
	return error('cannot find ${cid} for persons')
}

[params]
pub struct PersonFind {
pub mut:
	description string
	name        string // get in contact
	cid         string
	// TODO: see which other fields are relevant
}

// find persons in DB
// will look at person level as well as at contact level
// params:
// description   string
// name   string
pub fn (mut db PeopleDB) person_find(args_ PersonFind) []&Person {
	mut args := args_
	if args.cid.len > 0 {
		mut r := db.get(args.cid) or { return [] }
		return [r]
	}
	args.name = args.name.to_lower()
	args.description = args.description.to_lower()
	mut result := []&Person{}
	for _, person in db.persons {
		// TODO: do the find
		result << &person
	}
	return result
}
