module modelbase

import time
import freeflowuniverse.crystallib.timetools { time_from_string }

[heap]
pub struct Remark {
pub mut:
	content 	string
	time    	time.Time
	author_cid 	string  
}

[params]
pub struct RemarkArgs {
pub mut:
	content string
	time    string
	author  string
}

//? What is a remark?
// remark_add
// ARGS:
//     author = name (person name) or cid of author
// 	   time = 
pub fn (mut base Base) remark_add(remark RemarkArgs) !&Remark {
	// NEXT: need to implement using time conversion & look for author (with people manager using cid and name)
	base.remarks << remark
	mut t:=time_from_string(remark.time)!
	cid:= remark.author //NEXT: this can be wrong, if not CID used, we need to find way how to find an author
	return &Remark{time:t,content:remark.content,authod:cid}
}
