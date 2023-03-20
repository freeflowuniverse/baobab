module people

import freeflowuniverse.crystallib.actionsparser
import freeflowuniverse.baobab.modelbase
import time

pub enum PersonType {
	employee
	consultant
	investor
}

[heap]
pub struct Person {
	modelbase.Base
pub mut:
	guid        string
	description string
	start_date  time.Time
	end_date    time.Time
	contact     &Contact
	// paymentmethods 	[]finance.PaymentMethod	
	person_type PersonType
}

//
pub fn (mut db DB) process(text string) {
	actions := actionsparser.new(
		text: text
		filter: ['circle_delete', 'person_delete', 'circle_define', 'person_define', 'circle_link',
			'circle_comment', 'digital_payment_add']
		actor: 'people'
		book: 'aaa'
	)!
	for action in actions.ok {
		if action.name == 'circle_delete' {
			println(action.params)
		}
		// println(action)
	}
	println(actions_result)
	if true {
		panic('sssssdsdsd')
	}
}

pub fn person_delete(text string) {
}

// ## Add Contact Information
//
// ### ARGS:
//
// - firstname string
// - lastname string
// - description string
// pub fn (mut person Person) contact_add() !&Contact {
// 	mut o := Contact{
// 		firstname: person.firstname
// 		lastname: person.lastname
// 		description: person.description //? How to set this as optional if description not given
// 	}
// 	person.contact = &o
// 	// TODO any possible checks
// 	return person.contact
// }
