module modelbase



fn test_sid() ! {

	mut errmsg:=''
	_ := smartid_new("a") or {
		errmsg=err.str()
		modelbase.SmartId{}
	}
	assert errmsg.replace(" ","")=="SmartId cid is wrong for sid:a\nan id needs to be min length 3, max 6, here 'a'".replace(" ","")

	assert smartid_valid("a") == false 

	_ := smartid_new("aaaaaaa") or {
		errmsg=err.str()
		modelbase.SmartId{}
	}	
	assert errmsg.replace(" ","")=="SmartId cid is wrong for sid:aaaaaaa\nan id needs to be min length 3, max 6, here 'aaaaaaa'".replace(" ","")

	_ := smartid_new("aa.aaaa") or {
		errmsg=err.str()
		modelbase.SmartId{}
	}	
	assert errmsg.replace(" ","")=="SmartId bid is wrong for sid:aa.aaaa\nan id needs to be min length 3, max 6, here 'aa'".replace(" ","")

	sid := smartid_new("aa.aaaa.bbbb") or {
		errmsg=err.str()
		modelbase.SmartId{}
	}	
	assert errmsg.replace(" ","")=="SmartId rid is wrong for sid:aa.aaaa.bbbb\nan id needs to be min length 3, max 6, here 'aa'".replace(" ","")

	assert smartid_valid("z") == false 
	assert smartid_valid("zzz")
	assert smartid_valid("aaa")
	assert smartid_valid("000")
	assert smartid_valid("999")
	assert smartid_valid("000000")
	assert smartid_valid("999aaa")
	assert smartid_valid("000zzz")
	assert smartid_valid("a s") == false
	assert smartid_valid("a!s") == false
	assert smartid_valid("?") == false
	assert smartid_valid("aaa.aaa.aaa")
	assert smartid_valid("aaa.aaa.aaa000")
	assert smartid_valid("aaa.aaa999.aaa000")
	assert smartid_valid("aaa000.aaa999.aaa000")
	assert smartid_valid("aaa000.aaa999.aa")==false
	assert smartid_valid("aaa000.aaa999.aa$")==false
	assert smartid_valid("aaa000.aaa999.aaA")


	mut sid2:=SmartId{cid:"aaa"}
	assert sid2.str()=="sid:aaa"

	mut sid3:=SmartId{rid:"aaa",bid:"bbb",cid:"ccc"}
	assert sid3.str()=="sid:aaa.bbb.ccc"

}