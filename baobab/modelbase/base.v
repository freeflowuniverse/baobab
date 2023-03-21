module modelbase

import time

// TODO: need to discuss how to do this,
// maybe we need to use functionality from markdown parser,
// so we know how to go back there and save full file starting from the markdown file.

[heap]
struct Base {
pub mut:
	remarks      []Remark
	bid          string // link back to the id of the book, so we can find the book back
	content_path string // is string representing path towards the object, where was it coming from e.g. markdown file or text, then empty
}

[heap]
struct Remark {
pub mut:
	content string
	time    time.Time
	author  string
}

fn (mut base Base) save() ! {
	// TODO: use the wiki() functionality, now save properly to right location, need to think through how to do this
	// TODO: how can we make sure we only save the relevant parts of a wiki file?
	// TODO: if content_path not filled in is error
	// TODO: add content to the wiki to deal with the remarks
}

// TODO: add remarks (idea is that each object has ability to add/remove remarks), don't forget to serialize in wiki

/*
Duplicate
fn (mut data Data) remark_add(content string, time string,author string) ?&Remark {
	//TODO: need to implement using time conversion & look for author
	mut contr:=data.person_find(author)?
	time2:=timetools.get(time)?
	data.remarks<<Remark{author:contr,time:time2,content:content}
	return &Remark{}
}
*/

// //? What is a remark?
// // remark_add
// // ARGS:
// // author = full name of author
// fn (mut data Data) remark_add(content string, unix_time i64, author string) !&Remark {
// 	// TODO: need to implement using time conversion & look for author
// 	mut person := data.person_get(author)!
// 	data.remarks << Remark{
// 		author: person
// 		time: time.unix(unix_time)
// 		content: content
// 	}
// 	return &Remark{}
// }
