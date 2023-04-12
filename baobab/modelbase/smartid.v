module modelbase
import encoding.utf8

[heap]
pub struct SmartId {
pub mut:
	rid 		 string //regional internet id
	bid          string // link back to the id of the book, so we can find the book back}
	cid          string //content id
}

//return object form of a smart id
// is of form $rid.$bid.$cid or $bid.$cid or $cid
// each element a...z0...9
// min 3 max 6
pub fn smartid_new(smartid_ string)!SmartId{
	smartid:=smartid_.to_lower()
	// check is of our type
	splitted:=smartid.split(".")
	mut sid:=SmartId{}
	if splitted.len==1{
		//means only cid
		sid=SmartId{cid:splitted[0].trim_space()}
	} else if splitted.len==2{
		//means only cid
		sid=SmartId{cid:splitted[1].trim_space(),bid:splitted[0].trim_space()}
	} else if splitted.len==3{
		//means only cid
		sid=SmartId{cid:splitted[2].trim_space(),bid:splitted[1].trim_space(),rid:splitted[0].trim_space()}
	}else{
		return error("max . is 2 in smartid, for format \$rid.\$bid.\$cid or \$bid.\$cid or \$cid.\nNow:$smartid_")
	}
	sid.check()! //check if valid
	return sid
}

//will check validity of a smartid
fn (mut si SmartId) check() ! {
	check_id_format(si.rid) or {return error("SmartId rid is wrong for $si \n$err")}
	check_id_format(si.bid)or {return error("SmartId bid is wrong for $si \n$err")}
	check_id_format(si.cid)or {return error("SmartId cid is wrong for $si \n$err")}
	if si.cid.len<3 || si.cid.len>6{
		return error("an id needs to be min length 3, max 6, here '${si.cid}' for cid")					
	}		
}

//check chars are in a...z0...9
fn check_id_format(c string) ! {
	//48...57 is the ascii digits
	//97...122  Latin Alphabet Lowercase
	if c.len==0{
		return
	}
	if c.len<3 || c.len>6{
		return error("an id needs to be min length 3, max 6, here '${c}'")					
	}		
	// println("check_id_format $c ::: ${c.len}")
	for i in 0..c.len{
		u:=utf8.get_uchar(c,i)
		// println("$c ::: $i :::: $u")
		if u>47 && u<58 {
			continue
		}
		if u>96 && u<123 {
			continue
		}
		return error("SmartId not right format, each char needs to be part of a...z or 0...9, now: $c")
	}
}


fn (si SmartId) getstr() !string {
	if si.rid.len>0 {
		return "${si.rid}.${si.bid}.${si.cid}"
	}
	if si.bid.len>0{
		return "${si.bid}.${si.cid}"
	}
	if si.cid.len>0 {
		return si.cid
	}
	return error("smart id needs to have at least cid")
}


pub fn (mut si SmartId) str() string{
	a:=si.getstr() or {"empty"}
	return a
}

//make sure smartid is properly formatted, will return if we can fix it
pub fn smartid_fix(smartid string)!string{
	mut si:=smartid_new(smartid)!
	return si.str()
}

//return true if valid
pub fn smartid_valid(smartid string)bool{
	mut _:=smartid_new(smartid) or {return false}
	return true
}