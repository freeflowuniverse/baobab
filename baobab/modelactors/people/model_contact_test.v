module people

import freeflowuniverse.baobab.modelbase
import time

fn test_contact_new() ! {
	mut database := db('aaa')
	contact := database.contact_new(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!

	assert contact.cid == 'tst'
	assert contact.firstname == 'Test'
	assert contact.lastname == 'contact'
	assert contact.description == 'Test contact created for testing'
	assert contact.emails[0].addr == 'test@contact.test'
}

fn test_contact_update() ! {
	mut database := db('aaa')
	mut contact := database.contact_new(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!
	contact.update(
		firstname: 'Updated Test'
		lastname: 'contact'
		description: 'Updated test contact created for testing'
		emails: [Email{addr:'updated@contact.test'}]
	)!

	assert contact.cid == 'tst'
	assert contact.firstname == 'Updated Test'
	assert contact.lastname == 'contact'
	assert contact.description == 'Updated test contact created for testing'
	assert contact.emails[0].addr == 'updated@contact.test'
	
}

fn test_contact_define() ! {
	mut database := db('aaa')
	mut contact := database.contact_define(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!

	assert contact.cid == 'tst'
	assert contact.firstname == 'Test'
	assert contact.lastname == 'contact'
	assert contact.description == 'Test contact created for testing'
	assert contact.emails[0].addr == 'test@contact.test'
}

fn test_contact_find() ! {
	mut database := db('aaa')
	mut contact := database.contact_define(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!

	mut contacts := []&Contact{}
	contacts = database.contact_find(cid: 'tst')
	assert contacts[0].cid == 'tst'
	contacts = database.contact_find(lastname: 'test')
	contacts = database.contact_find(description: 'created for test')
}

fn test_contact_delete() ! {
	mut database := db('aaa')
	mut contact := database.contact_define(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!

	database.contact_delete('tst')!
	contacts := database.contact_find(cid: 'tst')
	assert contacts.len == 0
}

fn test_wiki() {
	mut database := db('aaa')
	mut contact := database.contact_define(
		cid: 'tst'
		firstname: 'Test'
		lastname: 'contact'
		description: 'Test contact created for testing'
		emails: [Email{addr:'test@contact.test'}]
	)!
	contact.wiki()
}