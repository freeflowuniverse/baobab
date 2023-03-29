module people

import freeflowuniverse.baobab.modelbase

fn test_person_new() ! {
	mut database := db('aaa')
	person := database.person_new(
		cid: 'tst'
	)!

	assert person.cid == 'tst'
}

fn test_person_update() ! {
	mut database := db('aaa')
	mut person := database.person_new(
		cid: 'tst'
	)!
	person.update(
		name: 'new neame'
	)!
}

fn test_person_define() ! {
	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
	)!
}

fn test_person_delete() ! {
	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
	)!

	database.person_delete('tst')!
	if new_person := database.person_cid_name_find('tst') {
		assert false
	} else {
		assert true
	}

}

fn test_wiki() {
	mut database := db('aaa')
	mut person := database.person_define(
		cid: 'tst'
	)!
	person.wiki()
}

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
