module people

import freeflowuniverse.baobab.modelbase

[heap]
pub struct Circle {
	modelbase.Base
pub mut:
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
	person      Person // TODO: por contact?
	state       PersonState
	description string
	role        Role
	// contribution_fee ContributionFee
	is_admin bool // can manage all properties of the circle
}
