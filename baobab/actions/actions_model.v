module actions

import freeflowuniverse.crystallib.params
import freeflowuniverse.crystallib.texttools

// A helper struct to parse actions from files to Action
pub struct ActionsManager {
pub mut:
	actions []Action
}

// Represents an action to be executed. This contains a name and
// some parameters. For more information on params please visit
// github/freeflowuniverse/crystallib/params/readme.md
pub struct Action {
pub:
	name string
pub mut:
	params params.Params
}

// Get the param as string, if it does not exist it will throw 
// an error
pub fn (mut action Action) param_get(name_ string) !string {
	return action.params.get(name_)
}

pub fn (action Action) str() string {
	p := 'ACTION: ${action.name}\n${action.params}'
	return p
}

// Returns a list of names, they are normalized (no special 
// chars, lowercase, ... )
pub fn (action Action) names() []string {
	mut names := []string{}
	for name in action.name.split('.') {
		names << texttools.name_fix(name)
	}
	return names
}

pub enum ActionState {
	init // first state
	next // will continue with next steps
	restart
	error
	done // means we don't process the next ones
}
