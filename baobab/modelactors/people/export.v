module people


//TODO: export to wiki

import freeflowuniverse.crystallib.actionsparser

[params]
pub struct Export {
pub:
	path string // can be dir or file
}

// processes text or path for actions
// the people db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db PeopleDB) export(args Export) {

	//export to path full structure in wiki format of this db (person, contact)
	
	// println(actions)
	if true {
		panic('dfdfdf')
	}
}
