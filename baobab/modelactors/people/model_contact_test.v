module people

import freeflowuniverse.baobab.modelbase
import time

fn test_contact_new() ! {
	mut database := db('aaa')
	person := database.contact_new(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'Person'
		description: 'Test Person created for testing'
		emails: [Email{addr:'test@person.test'}]
	)!

	assert person.cid == 'tst'
	assert person.firstname == 'Test'
	assert person.lastname == 'Person'
	assert person.description == 'Test Person created for testing'
	assert person.emails[0].addr == 'test@person.test'
}

// fn test_person_update() ! {
// 	mut database := db('aaa')
// 	mut person := database.person_new(
// 		cid: 'tst'
// 		contact: Contact {
// 			firstname: 'Test'
// 			lastname: 'Person'
// 			description: 'Test Person created for testing'
// 			emails: [Email{addr:'test@person.test'}]
// 		}
// 	)!
// 	person.update(
// 		contact: Contact {
// 			firstname: 'Updated Test'
// 			lastname: 'Person'
// 			description: 'Updated test Person created for testing'
// 			emails: [Email{addr:'updated@person.test'}]
// 		}
// 	)!
// }

// fn test_person_define() ! {
// 	mut database := db('aaa')
// 	mut person := database.person_define(
// 		cid: 'tst'
// 		contact: Contact {
// 			firstname: 'Test'
// 			lastname: 'Person'
// 			description: 'Test Person created for testing'
// 			emails: [Email{addr:'test@person.test'}]
// 		}
// 	)!
// }

// fn test_person_find() ! {

// 	mut database := db('aaa')
// 	mut person := database.person_define(
// 		cid: 'tst'
// 		contact: Contact {
// 			firstname: 'Test'
// 			lastname: 'Person'
// 			description: 'Test Person created for testing'
// 			emails: [Email{addr:'test@person.test'}]
// 		}
// 	)!

// 	mut persons := []&Person{}
// 	persons = database.person_find(cid: 'tst')
// 	assert persons[0].cid == 'tst'
// 	persons = database.person_find(name: 'test')
// 	persons = database.person_find(description: 'created for test')
// }

// fn test_person_delete() ! {
// 	mut database := db('aaa')
// 	mut person := database.person_define(
// 		cid: 'tst'
// 		contact: Contact {
// 			firstname: 'Test'
// 			lastname: 'Person'
// 			description: 'Test Person created for testing'
// 			emails: [Email{addr:'test@person.test'}]
// 		}
// 	)!

// 	database.person_delete('tst')!
// 	persons := database.person_find(cid: 'tst')
// 	assert persons.len == 0
// }

// fn test_wiki() {
// 	mut database := db('aaa')
// 	mut person := database.person_define(
// 		cid: 'tst'
// 		contact: Contact {
// 			firstname: 'Test'
// 			lastname: 'Person'
// 			description: 'Test Person created for testing'
// 			emails: [Email{addr:'test@person.test'}]
// 		}
// 	)!
// 	person.wiki()
// }