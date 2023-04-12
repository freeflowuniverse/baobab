module modelbase

import freeflowuniverse.crystallib.params 
// company structure
pub struct Company {
	Base
pub mut:
	circles []SmartId // link to circles
	testids []SmartId [alias:ids]  //if defined like this then the saving to filesystem will get alias called ids
	nr 	int = 10
	fl   f32 = 10.1
}


fn test_base() ! {
	sid1:=smartid_new("bbb.eeee")!
	sid2:=smartid_new("124.eeef")!
	mut c:=Company{
		sid:sid2		
		circles:[SmartId{cid:"aaa"},sid1]
		testids:[SmartId{cid:"ddd"},sid2]
		tags:"color:red urgent"
	}
	c_json := c.json_dump()!
	// println(c_json)
	assert c_json=='{"sid":{"rid":"","bid":"124","cid":"eeef"},"remarks":{"remarks":[]},"test":[],"tags":"color:red urgent","content_path":""}'

	c.remarks.add(author:'aaa',content:'something')!

	c.remarks.add(author:'ddd.aaa',content:'something else\nmore lines\ncool')!


	c.test=["a","b"]


	p := c.tags()!
	p2:= params.Params{
		params: [params.Param{
			key: 'color'
			value: 'red'
		}]
		args: ['urgent']
	}
	assert p == p2
	
	println(c)

	w:=wiki[Company](c,action:"company.add")!
	println(w)

	// mut res3:=action_obj_wiki[Company](c)!
	// println(res3)
	

	panic("s")
	
}