module main

import os
import freeflowuniverse.baobab.modelactors.people
import freeflowuniverse.crystallib.actionsparser

const data_file = os.dir(@FILE).all_before_last('/') + '/testdata/people_test.md'

fn main() {
	do() or { panic(err) }
}

fn do() ! {
	// parse actions
	parser := actionsparser.new(
		path: data_file
	)!
	println(parser)

	// process actions to load db
	mut people_db := people.db('aaa')
	people_db.process(parser.actions)!
	println(people_db)
}