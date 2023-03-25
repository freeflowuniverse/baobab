module people

// import freeflowuniverse.baobab.modelglobal.country
import freeflowuniverse.baobab.modelbase

[heap]
pub struct Contact {
	modelbase.Base
pub mut:
	cid 		string
	firstname   string
	lastname    string
	description string
	emails      []Email
	tel         []Tel
	addresses   []Address
}

pub struct ContactNewArgs {
pub mut:
	firstname   string
	lastname    string
	description string
}

pub struct Email {
pub mut:
	addr string
}

pub struct Tel {
pub mut:
	tel         string
	countrycode string // cca2
}

pub struct Address {
pub mut:
	street_nr   string
	city        string
	postalcode  string
	countrycode string // cca2
}

// creates new contact if contact defined doesn't exist, else updates contact
pub fn (mut db PeopleDB) contact_define(args Contact) !&Contact {
	mut contacts := db.contact_find(cid: args.cid)
	if contacts.len == 0 {
		return db.contact_new(args)
	} else if contacts.len == 1 {
		return contacts[0].update(args)
	} else {
		return error('Multiple contacts with same cid found.\nThis should never happen.')
	}
}

// create a new instance of a contact, can be changed after instantiation
fn (mut db PeopleDB) contact_new(args_ Contact) !&Contact {
	mut args := args_
	if args.cid == '' {
		args.cid = db.cid_new()
	}
	
	db.contacts << args
	return &db.contacts[db.contacts.len - 1]
}

// create a new instance of a contact, can be changed after instantiation
fn (mut contact Contact) update(args Contact) !&Contact {
	// contact.contact = &args.contact
	// contact.name = args.name
	return contact
}

// delete contact
pub fn (mut db PeopleDB) contact_delete(cid_ string) ! {
	cid := cid_.to_lower()
	// TODO2: delete from list
	for i, contact in db.contacts {
		if contact.cid == cid {
			db.contacts.delete(i)
			return
		}
	}

	return error('cannot find ${cid} for contacts')

}

// Add email address
// ARGS:
// - Email
pub fn (mut contact Contact) email_add(email Email) {
	contact.emails << email
	// TODO2 any possible checks)
}

// Add telephone
// ARGS:
// - Tel
pub fn (mut contact Contact) tel_add(tel Tel) {
	contact.tel << tel
	// TODO2 any possible checks
}

// Add address
// ARGS:
// - Address
pub fn (mut contact Contact) address_add(addr Address) {
	contact.addresses << addr
	// TODO2 any possible checks
}

struct ContactFind {
	cid string
	name string
	description string
	keyword string
	amount int
	relevance int
}

pub fn (mut db PeopleDB) contact_find(args_ Contact) []&Contact {
	// format args
	mut args := args_
	args.cid = args.cid.to_lower()

	// find by cid if db.get returns result
	if args.cid.len > 0 {
		if mut r := db.get(args.cid) {
			return [&(r as Contact)]
		}
	}
	
	mut result := []&Contact{}
	return result

	// config := utils.FindConfig{
	// 	fields: ['name']
	// 	keyword: args.keyword
	// 	relevance: 0
	// }

	// mut search := Person{
	// 	cid: args.cid
	// 	name: args.name
	// 	description: args.description
	// }
	// mut results := utils.find[Person](db.persons, search, config) or {
	// 	return []
	// }
	// return results.map(&db.persons[it])
}

// URGENT: implement contact