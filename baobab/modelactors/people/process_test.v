module people

import freeflowuniverse.crystallib.actionsparser
import os

const data_file = os.dir(@FILE) + '/testdata/people_test.md'

// Todo: more tests
fn test_process() ! {
	parser := actionsparser.new(
		defaultbook: 'aaa'
		path: data_file
	)!

	mut database := db('aaa')
	database.process(parser.actions)!

	// // process database manually
	// mut db_manual := db('aaa')
	// db_manual.person_delete('1gt') or {println(err)}
	// db_manual.person_define(
	// 	cid: '1gt'
	// 	name: 'fatayera'
	// 	contact: Contact{
	// 		firstname: 'Adnan'
	// 		lastname: 'Fatayerji'
	// 		description: 'Head of Business Development'
	// 		emails: [Email{addr:'adnan@threefold.io'}, Email{addr:'fatayera@threefold.io'}]
	// 	}
	// )!
	// db_manual.circle_define(
	// 	cid: 'tt0' 
  	// 	name: 'tftech'
  	// 	description: 'Developing planet first people first tech'
	// )!
	// db_manual.circle_link(
	// 	person: '1gt'
  	// 	circle: 'tftech'         
  	// 	role: 'stakeholder'
	// 	description:''
	// 	name:'vpsales'        
	// )!
	// db_manual.circle_comment(
	// 	person: '1gt'
  	// 	circle: 'tftech'         
  	// 	comment: 'this is a comment
	// 		can be multiline 
	// 	'
	// )!
	// db_manual.circle_comment(
	// 	person: '1gt'
  	// 	circle: 'tftech'         
  	// 	comment: 'another comment'
	// )!
	// db_manual.digital_payment_add(
	// 	person: 'fatayera'
	// 	name: 'TF Wallet'
	// 	blockchain: 'stellar'
	// 	account: ''
	// 	description: 'TF Wallet for TFT' 
	// 	preferred: false
	// )!

	panic(database)
}