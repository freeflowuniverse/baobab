module people

import freeflowuniverse.baobab.modelbase
import os

const data_file = os.dir(@FILE) + '/testdata/people_test.md'

fn test_circle_new() ! {
	mut database := db('aaa')
	circle := database.circle_new(
		cid: 'tst'
		name: 'test circle'
		description: 'circle made for testing'
	)!
	assert circle.cid == 'tst'
	assert circle.name == 'test circle'
	assert circle.description == 'circle made for testing'
}

fn test_circle_update() ! {
	mut database := db('aaa')
	mut circle := database.circle_new(
		cid: 'tst'
		name: 'test circle'
		description: 'circle made for testing'
	)!
	circle.update(
		cid: 'tst'
		name: 'circle updated'
		description: 'circle updated for testing'
	)!
	assert circle.cid == 'tst'
	assert circle.name == 'circle updated'
	assert circle.description == 'circle updated for testing'
}

fn test_circle_define() ! {
	mut database := db('aaa')
	mut circle := database.circle_define(
		cid: 'tst'
		name: 'test circle'
		description: 'circle made for testing'
	)!
}

pub fn test_circle_find() ! {
	mut database := db('aaa')

	mut circle := database.circle_define(
		cid: 'tt0'
		name: 'tftech'
		description: 'Developing planet first people first tech'
	)!

	mut args := CircleFind {
		cid: 'tt0'
	}
	
	mut circles := []&Circle{}
	circles = database.circle_find(args)
	assert circles.len == 1	
	assert circles[0].name == 'tftech'
	assert circles[0].cid == 'tt0'
	
	args = CircleFind {
		name: 'tftech'
	}
	
	circles = database.circle_find(args)
	assert circles.len == 1
	assert circles[0].name == 'tftech'
	assert circles[0].cid == 'tt0'

	// args = CircleFind {
	// 	description: 'planet first'
	// }
	
	// circles = database.circle_find(args)
	// assert circles.len == 1
	// assert circles[0].name == 'tftech'
	// assert circles[0].cid == 'tt0'

}

pub fn test_circle_link() ! {
	mut database := db('aaa')

	mut circle := database.circle_define(
		cid: 'tsc'
		name: 'test circle'
		description: 'circle made for testing'
	)!

	mut person := database.person_define(
		cid: 'tsp'
		contact: Contact {
			firstname: 'Test'
			lastname: 'Person'
		}
	)!

	mut args := CircleLink {
		circle: 'tsc'
		person: 'tsp'
		role: 'tester'
		description: 'description'
		name: 'vpsales'
	}

	database.circle_link(args)!

}

fn test_wiki() {
	mut circle := Circle{}
	circle.wiki()
}