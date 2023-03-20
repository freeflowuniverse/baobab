module modelbase

import time

[heap]
struct Base {
pub mut:
	remarks []Remark
}

[heap]
struct Remark {
pub mut:
	content string
	time    time.Time
	author  string
}

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
