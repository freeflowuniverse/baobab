module people

import freeflowuniverse.baobab.modelbase {cid_name_find}
import freeflowuniverse.baobab.modelactors.finance
import freeflowuniverse.baobab.utils
import time

[heap]
pub struct Person {
	modelbase.Base
pub mut:
	name string
	cid string
	description string    // description of the link to the person as contact
	start_date  time.Time // if we make link to person into our own book, we can have start/end date
	end_date    time.Time
	contact  &Contact // this has the effective information to the person = contact
	paymentmethods 	[]finance.PaymentMethod	
	// person_type PersonType
}

pub fn (mut person Person) wiki() string {
	return $tmpl('templates/person.md')
}

// creates new person if person defined doesn't exist, else updates person
// QUESTION: can you update through person_define
// creates new person if person defined doesn't exist, else updates person
pub fn (mut db PeopleDB) person_define(args Person) !&Person {
	if mut person := db.person_cid_name_find(args.cid) {
		return person.update(args)
	}
	return db.person_new(args)
}


// create a new instance of a person, can be changed after instantiation
// QUESTION: can you also define a person with payments  etc?
// QUESTION: can you predetermine cid?
fn (mut db PeopleDB) person_new(args_ Person) !&Person {
	mut args := args_
	mut cid := args.cid
	if args.cid == '' {
		cid = db.cid_new()
	}
	
	mut p := Person{
		cid: cid
		name: args.name
		description: args.description    // description of the link to the person as contact
		start_date: args.start_date // if we make link to person into our own book, we can have start/end date
		end_date: args.end_date
	}
	
	db.persons << p
	return &db.persons[db.persons.len - 1]
}

// create a new instance of a person, can be changed after instantiation
fn (mut person Person) update(args Person) !&Person {
	person.name = args.name
	person.description = args.description
	person.start_date = args.start_date
	person.end_date = args.end_date
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

pub fn (db PeopleDB) person_cid_name_find(cid_name string) ?&Person {
	index := cid_name_find(db.persons, cid_name) or {
		panic(err)
	}
	if index == -1 {
		return none
	}
	return &db.persons[index]
} 

[params]
struct DigitalPaymentAdd {
	person string
	name string
	blockchain string
	account string
	description string
	preferred bool
}

[params]
struct PersonLinkContact {
	person string
	contact string
}
pub fn (mut db PeopleDB) person_link_contact(args PersonLinkContact) !&Person {
	//QUESTION: good error handling?
	mut person := db.person_cid_name_find(args.person) or {
		return error('Failed to attach contact: $args.contact to person: $args.person\n
		Cannot find person $args.person')
	}
	contact := db.contact_cid_name_find(args.contact) or {
		return error('Failed to attach contact: $args.contact to person: $args.person\n
		Cannot find contact $args.contact')
	}
	
	person.link_contact(contact)!
	return person
}

pub fn (mut db PeopleDB) digital_payment_add(args DigitalPaymentAdd) !finance.PaymentMethod {
	mut person := db.person_cid_name_find(args.person) or {
		return error('Failed to add digital payment method. Failed to find person.')
	}
	return person.digital_payment_add(
		name: args.name
		blockchain: args.blockchain
		account: args.account
		description: args.description
		preferred: args.preferred
	)
}

//TODO: implement
// [params]
// pub struct PersonFind {
// pub mut:
// 	description string
// 	name        string // get in contact
// 	cid         string
// 	keyword string
// 	amount int = 1
// }

// // find persons in DB
// // will look at person level as well as at contact level
// // params:
// // description   string
// // name   string
// pub fn (mut db PeopleDB) person_find(args_ PersonFind) []&Person {
// 	mut args := args_
// 	if args.cid.len > 0 {
// 		mut r := db.get(args.cid) or { return [] }
// 		return [&(r as Person)]
// 	}
// 	args.name = args.name.to_lower()
// 	args.description = args.description.to_lower()
// 	mut result := []&Person{}
// 	mut i := 0
// 	config := utils.FindConfig{
// 		fields: ['cid', 'name']
// 		keyword: args.keyword
// 		amount: args.amount
// 		relevance: 10
// 	}
// 	mut search := Person{
// 		cid: args.cid
// 		name: args.name
// 		description: args.description
// 	}
// 	mut results := utils.find[Person](db.persons, search, config) or {
// 		return []
// 	}
// 	return results.map(&db.persons[it])
// }