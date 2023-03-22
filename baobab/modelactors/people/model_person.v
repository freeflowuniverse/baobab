module people

import freeflowuniverse.baobab.modelbase
import time

[heap]
pub struct Person {
	modelbase.Base
pub mut:
	cid string
	description string    // description of the link to the person as contact
	start_date  time.Time // if we make link to person into our own book, we can have start/end date
	end_date    time.Time
	contact  &Contact // this has the effective information to the person = contact
	// paymentmethods 	[]finance.PaymentMethod	
	// person_type PersonType
}

pub fn (mut o Person) wiki() string {
	// TODO: fill in template
	return $tmpl('templates/person.md')
}

struct PersonDefine {
	cid string
	contact Contact
}

// creates new person if person defined doesn't exist, else updates person
pub fn (mut db PeopleDB) person_define(args PersonDefine) !&Person {
	mut persons := db.person_find(cid: args.cid)
	if persons.len == 0 {
		return db.person_new(args)
	} else if persons.len == 1 {
		return persons[0].update(args)
	} else {
		return error('Multiple persons with same cid found.\nThis should never happen.')
	}
}

// create a new instance of a person, can be changed after instantiation
pub fn (mut db PeopleDB) person_new(args_ PersonDefine) !&Person {
	mut args := args_
	mut cid := args.cid
	if args.cid == '' {
		cid = db.cid_new()
	}
	
	mut p := Person{
		cid: cid
		contact: &args.contact
	}
	
	db.persons << p
	return &db.persons[db.persons.len - 1]
}

// create a new instance of a person, can be changed after instantiation
pub fn (mut person Person) update(args PersonDefine) !&Person {
	person.contact = &args.contact
	return person
}

// delete person
pub fn (mut db PeopleDB) person_delete(cid_ string) ! {
	cid := cid_.to_lower()
	// TODO: delete from list
	for i, person in db.persons {
		if person.cid == cid {
			db.persons.delete(i)
			return
		}
	}

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

