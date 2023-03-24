module people

// import freeflowuniverse.baobab.modelglobal.country
import freeflowuniverse.baobab.modelbase

[heap]
pub struct Contact {
	modelbase.Base
pub mut:
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

// Add email address
// ARGS:
// - Email
pub fn (mut contact Contact) email_add(email Email) {
	contact.emails << email
	// TODO any possible checks)
}

// Add telephone
// ARGS:
// - Tel
pub fn (mut contact Contact) tel_add(tel Tel) {
	contact.tel << tel
	// TODO any possible checks
}

// Add address
// ARGS:
// - Address
pub fn (mut contact Contact) address_add(addr Address) {
	contact.addresses << addr
	// TODO any possible checks
}
