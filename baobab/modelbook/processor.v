module modelbook

// import freeflowuniverse.crystallib.currency
import freeflowuniverse.baobab.modelbook.people
import freeflowuniverse.crystallib.actions
// import time

// parses format in params text
pub fn (mut db DBBData) process(text string) ! {
	// println(text)
	parser := actions.text_parse(text)!
	for action in parser.actions {
		if action.name == 'data.book.select' {
			println(action.params)
		}

		// println(action)
		if true {
			panic('sssssdsdsd')
		}
	}
	// return Person{}
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
