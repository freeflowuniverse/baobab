module people

import freeflowuniverse.crystallib.actionsparser { Action, FilterArgs, filtersort }


// QUESTION: filter in process or outside


// processes text or path for actions
// the people db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db PeopleDB) process(actions_ []Action) ! {

	args := FilterArgs {
		actor: 'people'
		book: 'aaa'
	}
	actions := filtersort(actions_, args)!

	for action in actions {
		db.execute(action)!
	}
}

pub fn (mut db PeopleDB) execute(action actionsparser.Action) ! {
	// ? not in actions as discussed
	if action.name == 'book.select' {
		println(action.params)
		// NEXT: nothing to do needs to be on higher level
	}
	if action.name.ends_with('person_delete') {
		cid := action.params.get('cid')!
		db.person_delete(cid)!
	}
	if action.name.ends_with('person_define') {
		cid := action.params.get('cid')!
		name := action.params.get('name')!
		person := db.person_define(
			cid: cid
			name: name
		)!
	}
	if action.name.ends_with('circle_define') {
		mut circle_args := action.params.decode[CircleArgs]()!
		circle := db.circle_define(circle_args)!
	}
	if action.name.ends_with('contact_define') {
		mut contact := action.params.decode[Contact]()!
		person := db.contact_define(contact)!
	}
	if action.name.ends_with('person_link_contact') {
		mut args := action.params.decode[PersonLinkContact]()!
		person := db.person_link_contact(args)!
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
