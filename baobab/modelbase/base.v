module modelbase

import freeflowuniverse.crystallib.params 
import json

[heap]
struct Base {
pub mut:
	sid 		 SmartId
	remarks      Remarks
	test         []string
	tags		 string //is the way how we can find rootobjects back
	content_path string // is string representing path towards the object, where was it coming from e.g. markdown file or text, then empty
}

[heap]
struct BaseNamed{
	Base
pub mut:
	name           string
	description    string
}


pub fn (mut base Base) check() ! {
	base.sid.check()!
}

pub fn (mut base Base) is_valid() bool {
	base.check() or {return false}
	return true
}

pub fn (mut base Base) tags() !params.Params {
	return params.new(base.tags)!
}


//QUESTION: why not use regular json library
pub fn (mut base Base) json_dump() !string {
	base.check()!
	jsonstring := json.encode(base)
	return jsonstring
}


// pub fn action_prop_encode[T](t T) ! string {
// 	$for field in T.fields {
// 		println(field)
// 	}	
// }
