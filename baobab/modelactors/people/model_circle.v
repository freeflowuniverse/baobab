module people

import freeflowuniverse.baobab.modelbase
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
	// TODO2: fill in template
	return $tmpl('templates/circle.md')
}

// creates new person if person defined doesn't exist, else updates person
pub fn (mut db PeopleDB) circle_define(args CircleArgs) !&Circle {
	mut circles := db.circle_find(cid: args.cid)
	if circles.len == 0 {
		return db.circle_new(args)
	} else if circles.len == 1 {
		return circles[0].update(args)
	} else {
		return error('Multiple circles with same cid found.\nThis should never happen.')
	}
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
pub mut:
	description string
	name        string // get in contact
	cid         string
	keyword 	string // applies to all
	amount	int = 1 // number of results wanted
	// TODO2: see which other fields are relevant
}

// find circles in DB
// will look at person level as well as at contact level
// params:
// description   string
// name   string
// keyword string // if keyword provided, it checks until finds a match
pub fn (mut db PeopleDB) circle_find(args_ CircleFind) []&Circle {
	mut args := args_
	if args.cid.len > 0 {
		mut r := db.get_circle(args.cid) or { return [] }
		return [r]
	}
	args.name = args.name.to_lower()
	args.description = args.description.to_lower()
	args.keyword = args.keyword.to_lower()
	mut result := []&Circle{}
	mut i := 0
	for {
		if i == db.circles.len {
			break
		}
		if db.circles[i].name == args.name {
			result << &db.circles[i]
			if result.len == args.amount {
				return result
			}
		}
		if db.circles[i].name == args.keyword {
			result << &db.circles[i]
			if result.len == args.amount {
				return result
			}
		// }
		// db.circles[i].name == args.keyword || 
		// db.circles[i].description.contains(args.description)
		// {
			result << &db.circles[i]
		} 
		i += 1
	}
	return result
}

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
	mut circles := db.circle_find(cid: args.circle)
	if circles.len == 0 {
		// maybe provided circle param is not cid but name
		circles = db.circle_find(name: args.circle)
	}
	if circles.len == 0 {
		return error('Failed to find circle $args.circle')
	}

	// get person
	mut persons := db.person_find(cid: args.person)
	if persons.len == 0 {
		// maybe provided circle param is not cid but name
		persons = db.person_find(name: args.person)
	}
	if persons.len == 0 {
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
		person: persons[0]
		state: .uncertain
		description: args.description
		name: args.name
		role: role
	}
	circles[0].members << member
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
	mut circles := db.circle_find(cid: args.circle)
	if circles.len == 0 {
		// maybe provided circle param is not cid but name
		circles = db.circle_find(name: args.circle)
	}
	if circles.len == 0 {
		return error('Failed to find circle $args.circle')
	}

	// get person
	mut persons := db.person_find(cid: args.person)
	if persons.len == 0 {
		// maybe provided circle param is not cid but name
		persons = db.person_find(name: args.person)
	}
	if persons.len == 0 {
		return error('Failed to find person $args.person')
	}

	circles[0].remark_add(
		author: persons[0].cid
		content: args.comment
		time: time.now()
	)!
}
