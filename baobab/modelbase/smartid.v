module modelbase

import time

// TODO: need to discuss how to do this,
// maybe we need to use functionality from markdown parser,
// so we know how to go back there and save full file starting from the markdown file.

[heap]
pub struct SmartId {
pub mut:
	rid 		 string
	cid          string
	bid          string // link back to the id of the book, so we can find the book back}
}

//return object form of a smart id
// is of form $rid.$bid.$cid or $bid.$cid or $cid
// each element a...z0...9
// min 3 max 6
pub fn smartid_new(smartid_ string)!SmartId{
	smartid:=smartid_.to_lower()
	//URGENT: parse with 1 . or 2 or 3
	// check is of our type
	si:=SmartId{cid:"aaa"} //FIXME: temp
	si.check()! //check if valid
	return si
}

//will check validity of a smartid
fn (mut si SmartId) check() ! {
	_:=si.getstr()!
}


fn (mut si SmartId) getstr()!{
	if si.rid.len>0{
		if si.bid.len<3 || si.bid.len>6{
			return error("when rid used, a bid is needed and min length is 3, max 6, here ${si.bid}")					
		}
		if si.cid.len<3 || si.cid.len>6{
			return error("when rid used, a cid is needed and min length is 3, max 6, here ${si.cid}")					
		}
		return "${si.rid}.${si.bid}.${si.cid}"
	}
	if si.bid.len>0{
		if si.cid.len<3 || si.cid.len>6{
			return error("when rid used, a cid is needed and min length is 3, max 6, here ${si.cid}")					
		}
		return "${si.bid}.${si.cid}"
	}
	if si.cid.len<3 || si.cid.len>6{
		return error("when rid used, a cid is needed and min length is 3, max 6, here ${si.cid}")					
	}	
	return "${si.cid}"
}


pub fn (mut si SmartId) str()string{
	return si.getstr() or {panic(err)}
}

//make sure smartid is properly formatted, will return if we can fix it
pub fn smartid_fix(smartid string)!string{
	si:=smartid_new(smartid)!
	return si.str()
}