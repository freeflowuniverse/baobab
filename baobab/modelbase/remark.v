module modelbase

import time
import freeflowuniverse.crystallib.timetools { parse }

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
	//QUESTION: why not pass in remark rather than remark args
	mut t:=parse(remark.time)!
	cid:= remark.author //NEXT: this can be wrong, if not CID used, we need to find way how to find an author
	new_remark := &Remark{time:t,content:remark.content,author_cid:cid}
	base.remarks << new_remark
	return new_remark
}
