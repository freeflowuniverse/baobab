module modelbase

import freeflowuniverse.crystallib.params {Params}

// NEXT: need to discuss how to do this,
// maybe we need to use functionality from markdown parser,
// so we know how to go back there and save full file starting from the markdown file.

[heap]
struct Base {
pub mut:
	sid 		 SmartId
	remarks      []Remark
	tags		 Params //is the way how we can find rootobjects back
	content_path string // is string representing path towards the object, where was it coming from e.g. markdown file or text, then empty
}

[heap]
struct BaseNamed{
	Base
pub mut:
	name           string
	description    string
}



//QUESTION: why not use regular json library
fn (mut base Base) json_dump() ! {
	// URGENT: make this generic so all can be used
}

// NEXT: add remarks (idea is that each object has ability to add/remove remarks), don't forget to serialize in wiki


fn (mut base Base) save() ! {
	// NEXT: use the wiki() functionality, now save properly to right location, need to think through how to do this
	// NEXT: how can we make sure we only save the relevant parts of a wiki file?
	// NEXT: if content_path not filled in is error
	// NEXT: add content to the wiki to deal with the remarks
}

// NEXT: add remarks (idea is that each object has ability to add/remove remarks), don't forget to serialize in wiki
