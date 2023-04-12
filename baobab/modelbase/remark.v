module modelbase

import time
import freeflowuniverse.crystallib.timetools
import freeflowuniverse.crystallib.texttools


[heap]
pub struct Remarks {
pub mut:
	remarks 	[]Remark
}

pub struct Remark {
pub mut:
	content 	string
	time    	time.Time
	author 		SmartId
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
pub fn (mut remarks Remarks) add(remark RemarkArgs) ! {
	// NEXT: need to implement using time conversion & look for author (with people manager using cid and name)
	//QUESTION: why not pass in remark rather than remark args	
	mut t:=timetools.parse(remark.time)!
	sid:= smartid_new(remark.author)!
	new_remark := Remark{time:t,content:remark.content,author:sid}
	remarks.remarks << new_remark
}

pub fn ( remarks Remarks) wiki() !string {
	mut out:=""
	for remark in remarks.remarks{
		a:=remark.author.getstr()!
		out+="!!remark.add cid:@cid time:'${remark.time}' author:$a\n"
		if remark.content.contains("\n"){
			//multiline
			out+= "    content:'\n"
			out+= texttools.indent(remark.content,"    ")
			if ! remark.content.ends_with("\n"){
				out+="\n"
			}
			out+="    '\n"
		}else{
			out+= "    content:${remark.content}'\n"
		}
	}
	return out
}
