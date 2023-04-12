module company

import freeflowuniverse.crystallib.actionsparser

// [params]
// pub struct ProcessArgs {
// pub:
// 	text string
// 	path string // can be dir or file
// }

// processes text or path for actions
// the company db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db CompanyDB) process(actions:parser.actions) ! {
	// println('args: $args.path')
	// parser := actionsparser.new(
	// 	text: args.text
	// 	path: args.path
	// 	defaultactor: db.actor
	// 	defaultbook: db.bid
	// )!

	db.process_cost(actions)!
	db.process_company(actions)!

}

