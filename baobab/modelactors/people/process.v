module people

import freeflowuniverse.crystallib.actionsparser

[params]
pub struct ProcessArgs {
pub:
	text   string
	path   string   // can be dir or file
}



// processes text or path for actions
// the people db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db PeopleDB) process(args ProcessArgs) {
	actions := actionsparser.new(
		text:args.text
		path:args.path
		filter: db.filter
		actor: db.actor
		book: db.bid
	)!

	for action in actions.ok {
		if action.name == 'data.book.select' {
			println(action.params)
			//TODO: nothing to do needs to be on higher level
		}
		if action.name == 'data.book.delete' {
			// db.person_delete(actions.params...) 
		}		
		if action.name == 'data.book.new' {
			mut o:=db.person_new()
			// o.name=action.params...
		}		

		// println(action)
		if true {
			panic('sssssdsdsd')
		}
	}

	println(actions)
	if true {
		panic('sssssdsdsd')
	}
}

