module people

import freeflowuniverse.baobab.modelbase
import time

fn test_wiki() {
	mut person := Person{}
	person.wiki()
}

fn test_person_new() ! {
	mut database := db('aaa')
	person := database.person_new(
		cid: 'tst'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
			description: 'Test Person created for testing'
			emails: [Email{addr:'test@person.test'}]
		}
	)!
}

fn test_person_update() ! {
	mut database := db('aaa')
	mut person := database.person_new(
		cid: 'tst'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
			description: 'Test Person created for testing'
			emails: [Email{addr:'test@person.test'}]
		}
	)!
	person.update(
		contact: Contact {
			firstname: 'Updated Test'
			lastname: 'Person'
			description: 'Updated test Person created for testing'
			emails: [Email{addr:'updated@person.test'}]
		}
	)!
}

fn test_person_define() ! {
	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
			description: 'Test Person created for testing'
			emails: [Email{addr:'test@person.test'}]
		}
	)!
}

fn test_person_find() ! {

	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
			description: 'Test Person created for testing'
			emails: [Email{addr:'test@person.test'}]
		}
	)!

	mut persons := []&Person{}
	persons = database.person_find(cid: 'tst')
	persons = database.person_find(name: 'test')
	persons = database.person_find(description: 'created for test')
}

fn test_person_delete() ! {
	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
			description: 'Test Person created for testing'
			emails: [Email{addr:'test@person.test'}]
		}
	)!

	database.person_delete('tst')!
	persons := database.person_find(cid: 'tst')
	assert persons.len == 0
}

