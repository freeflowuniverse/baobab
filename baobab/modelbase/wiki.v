module modelbase
import freeflowuniverse.crystallib.pathlib 

pub struct WikiActionObj{
pub mut:
	name string
	name_original string
	wiki string
	action bool
}

// go overa all properties of an object return as map of string with strings as value
pub fn action_obj_wiki[T](t T) ! []WikiActionObj {
	mut out:=[]WikiActionObj{}
	$for field in T.fields {
		// println(field)
		mut wao:=WikiActionObj{name:field.name}
		attrs:=field.attrs
		if attrs.len>0{
			for att in attrs{
				// println(" --- '$att'")
				if att.contains(":"){
					splitted:=att.split(":")
					attr_action := splitted[0].trim_space()
					attr_val:=splitted[1].trim_space().trim("'").trim_space().trim("\"").trim_space()
					if attr_action=="alias"{
						wao.name_original = wao.name
						wao.name=attr_val
					}
				}
				if att.trim_space() == "action"{
					wao.action=true
				}
			}
		}
		valstr:=""
		$if field.typ is int {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao
		}$else $if field.typ is f32 {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao
		}$else $if field.typ is u8 {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao			
		}$else $if field.typ is u16 {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao			
		}$else $if field.typ is u32 {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao
		}$else $if field.typ is u64 {			
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao
		}$else $if field.typ is string {	
			val:=t.$(field.name)
			wao.wiki="$val"		
			out<<wao
		}$else $if field.typ is Base {
			// println(" - base: ${field.name}")
			waos := action_obj_wiki[Base](t.Base)!
			for wao2 in waos{
				out<<wao2
			}
		}$else $if field.typ is SmartId {
			wao.wiki=t.$(field.name).getstr()!
			out<<wao			
		}$else $if field.typ is Remarks {
			mut val:=t.$(field.name).wiki()!	
			if !val.ends_with("\n"){
				val+="\n"
			}	
			wao.action = true
			wao.wiki=val
			out<<wao
		}$else $if field.is_array {	
			// println(" - array: ${field.name}")
			val := t.$(field.name)			
			mut wiki:=""
			// convert items to string
			for i in val{
				wiki+="${i},"
			}
			wao.wiki=wiki.trim_right(",")
			out<<wao
		}$else $if field.is_struct {
			val:=t.$(field.name)
			wao.wiki="$val"
			out<<wao				
		}$else $if field.is_map {
		// }$else{
		// 	return error("Cannot get the properties of an action object, because found a property of unsupported type for '$field.name', type:${field.typ}")
		}
		// println(wao)

	}
	return out
}

[params]
pub struct SaveArgs{
pub:
	human_id string //can be empty, its how it can be saved in FS (human friendly name)
	// cid string
	bid string		//optional, if not used then output only valid in current book
	rid string		//optional, if not used then output only valid in current regional internet
	action string    //in the book and regionalinternet, 
	// action_args map[string]string //can be empty, during reflection will use the ones we don't know yet
	path string
}

//generate wiki for action
pub fn wiki[T](t T,args SaveArgs) !string {
	mut out:=""
	if args.action.len==0 {
		return error("action needs to be defined")
	}
	if args.rid.len>0 {
		out+="!!select_internet ${args.rid}\n"
	}

	if args.bid.len>0 {
		out+="!!select_book ${args.bid}\n"
	}
	if t.sid.cid.len==0{
		return error("cid needs to be filled in in object.")
	}

	out+="!!${args.action}\n"
	mut actionexists:=false
	mut items:=action_obj_wiki[T](t)!
	// println(items)
	// if true{panic("Sds")}
	for item in items{
		if item.action{
			actionexists=true
			continue
		}
		if item.wiki!=""{
			out+="    $item.name: '${item.wiki}'\n"
		}		
	}
	if actionexists{
		out+="\n"
		for item in items{
			if item.action{	
				mut wiki:=item.wiki
				if t.sid.cid.len>0{
					wiki=wiki.replace("@cid",t.sid.cid)
				}else{
					if wiki.contains("@cid"){
						return error("@cid is in wiki but not specified when calling wiki()")
					}
				}
				out+="$wiki\n\n"
			}		
		}		
	}
	return out
}


pub fn save[T](t T,args SaveArgs) !string {
	w:=wiki[T](t,args)!
	if args.path.len==0{
		return error("path cannot be empty.")
	}
	mut ff:=pathlib.get_file(args.path,true)!
	ff.write(w)!
}

// NEXT: add remarks (idea is that each object has ability to add/remove remarks), don't forget to serialize in wiki
