module company

import freeflowuniverse.crystallib.actionsparser
import os

const data_dir = os.dir(@FILE) + '/testdata'

// Todo: more tests
fn test_process() ! {
	mut database := db('aaa',"usd")
	database.process(path: data_dir)!

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
  	// 	description: 'Developing planet first company first tech'
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