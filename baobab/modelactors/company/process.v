module company

import freeflowuniverse.crystallib.actionsparser

[params]
pub struct ProcessArgs {
pub:
	text string
	path string // can be dir or file
}

// processes text or path for actions
// the company db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db CompanyDB) process(args ProcessArgs) ! {
	println('args: $args.path')
	actions := actionsparser.new(
		text: args.text
		path: args.path
		filter: db.filter
		actor: db.actor
		book: db.bid
	)!

	for action in actions.ok {
		db.execute(action) or {
			handle_error(err)
			continue
		}
	}
}

pub fn (mut db CompanyDB) execute(action actionsparser.Action) ! {
	// ? not in actions as discussed
	if action.name == 'book.select' {
		println(action.params)
		// TODO: nothing to do needs to be on higher level
	}
	//TODO: execute the actions for company
	// if action.name.ends_with('person_delete') {
	// 	cid := action.params.get('cid')!
	// 	db.person_delete(cid)!
	// }
	// if action.name.ends_with('person_define') {
	// 	cid := action.params.get('cid')!
	// 	name := action.params.get('name')!
	// 	mut contact := action.params.decode[Contact]()!
	// 	person := db.person_define(
	// 		cid: cid
	// 		contact: contact
	// 		name: name
	// 	)!
	// }
	// if action.name.ends_with('circle_define') {
	// 	mut circle_args := action.params.decode[CircleArgs]()!
	// 	circle := db.circle_define(circle_args)!
	// }
	if action.name.ends_with('person_de') {
		mut contact := action.params.decode[Contact]()!
		person := db.person_define(contact: contact)!
	}
	if action.name.ends_with('circle_define') {
		mut circle_args := action.params.decode[CircleArgs]()!
		circle := db.circle_define(circle_args)!
	}
	if action.name.ends_with('circle_link') {
		mut link_args := action.params.decode[CircleLink]()!
		db.circle_link(link_args)!
	}
	if action.name.ends_with('digital_payment_add') {
		mut add_args := action.params.decode[DigitalPaymentAdd]()!
		db.digital_payment_add(add_args)!
	}
	// // println(action)
	// if true {
	// 	panic('sssssdsdsd')
	// }
}

//? how to better handle errors
pub fn handle_error(err IError) {
	println(err)

}