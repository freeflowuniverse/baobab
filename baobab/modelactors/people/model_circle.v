module people

import freeflowuniverse.baobab.modelbase {cid_name_find}
import freeflowuniverse.baobab.utils
import time

[heap]
pub struct Circle {
	modelbase.Base
pub mut:
	cid 		string
	name        string
	description string
	members     []CircleMember
}

pub enum PersonState {
	active
	inactive
	uncertain
}

pub enum Role {
	stakeholder
	member
	contributor
	follower
	viewer
}

pub struct CircleMember {
pub mut:
	name string
	person      &Person // TODO: make sure is implemented
	state       PersonState
	description string
	role        Role
	// contribution_fee ContributionFee
	is_admin bool // can manage all properties of the circle
}

struct CircleArgs {
	name string
	description string
	cid string
}

pub fn (mut circle Circle) wiki() string {
	// NEXT: fill in template
	return $tmpl('templates/circle.md')
}

// creates new person if person defined doesn't exist, else updates person
pub fn (mut db PeopleDB) circle_define(args CircleArgs) !&Circle {
	if mut circle := db.circle_cid_name_find(args.cid) {
		return circle.update(args)
	}
	return db.circle_new(args)
}

// create a new instance of a person, can be changed after instantiation
pub fn (mut db PeopleDB) circle_new(args_ CircleArgs) !&Circle {
	mut args := args_
	mut cid := args.cid
	if args.cid == '' {
		cid = db.cid_new()
	}
	
	mut c := Circle{
		cid: cid
		name: args.name
		description: args.description
	}
	
	db.circles << c
	//? is this necessary or can just return &c
	return &db.circles[db.circles.len - 1]
}

// create a new instance of a person, can be changed after instantiation
pub fn (mut circle Circle) update(args CircleArgs) !&Circle {
	circle.name = args.name
	circle.description = args.description
	return circle
}

[params]
pub struct CircleFind {
	Circle
pub mut:
	relevance int
	name        string // get in contact
	cid         string
	keyword 	string // applies to all
	amount	int = 1 // number of results wanted
	// NEXT: see which other fields are relevant
}

// // find circles in DB
// // will look at person level as well as at contact level
// // params:
// // description   string
// // name   string
// // keyword string // if keyword provided, it checks until finds a match
// pub fn (mut db PeopleDB) circle_find(args_ CircleFind) []&Circle {
// 	// format args
// 	mut args := args_
// 	args.cid = args.cid.to_lower()

// 	// find by cid if db.get returns result
// 	if args.cid.len > 0 {
// 		if mut r := db.get(args.cid) {
// 			return [&(r as Circle)]
// 		}
// 	}
	
// 	mut result := []&Circle{}
// 	config := utils.FindConfig{
// 		// fields: ['cid', 'emails', 'tel', 'firstname', 'lastname', 'description', 'addresses'] // priority of field matches
// 		keyword: args.keyword
// 		relevance: args.relevance
// 	}

// 	mut results := utils.find[Circle](db.circles, args.Circle, config) or {
// 		return []
// 	}
// 	return results.map(&db.circles[it])
// }

pub struct CircleLink{
mut:
	person string
	circle string
	role string
	description string
	name string
}

pub fn (mut db PeopleDB) circle_link(args_ CircleLink) ! {
	mut args := args_
	if args.person.len == 0 {
		return error('Need person id or name to link to circle')
	}
	if args.circle.len == 0 {
		return error('Need circle id or name to link to circle')
	}

	args.name = args.name.to_lower()
	args.circle = args.circle.to_lower()
	args.description = args.description.to_lower()
	args.role = args.role.to_lower()

	// get circle
	mut circle := db.circle_cid_name_find(args.circle) or {
		return error('Failed to find circle $args.circle')
	}

	// get person
	mut person := db.person_cid_name_find(args.person) or {
		return error('Failed to find person $args.person')
	}

	mut role := Role.member
	match args.role {
		'stakeholder' {role = Role.stakeholder}
		'member' {role = Role.member}
		'contributor' {role = Role.contributor}
		'follower' {role = Role.follower}
		'viewer' {role = Role.viewer}
		else {}
	}

	member := CircleMember{
		person: person
		state: .uncertain
		description: args.description
		name: args.name
		role: role
	}
	circle.members << member
}

struct CircleComment{
	circle string
	person string
	comment string
}

pub fn (mut db PeopleDB) circle_comment(args_ CircleComment) ! {
	mut args := args_
	if args.person.len == 0 {
		return error('Need person id or name to link to circle')
	}
	if args.circle.len == 0 {
		return error('Need circle id or name to link to circle')
	}

	// get circle
	mut circle := db.circle_cid_name_find(args.circle) or {
		return error('Failed to find circle $args.circle')
	}

	// get person
	mut person := db.person_cid_name_find(args.person) or {
		return error('Failed to find person $args.person')
	}

	circle.remark_add(
		author: person.cid
		content: args.comment
		time: time.now().format()
	)!
}

pub fn (db PeopleDB) circle_cid_name_find(cid_name string) ?&Circle {
	index := cid_name_find(db.circles, cid_name) or {
		panic(err)
	}
	if index == -1 {
		return none
	}
	return &db.circles[index]
} 