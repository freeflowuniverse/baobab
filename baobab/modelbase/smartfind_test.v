module modelbase

struct TestStruct {
	cid string
	name string
	description string
}

fn generate_list() []TestStruct {
	return [
		TestStruct{
			cid: 'aaa'
			name: 'alpha'
			description: 'first struct'
		}, 
		TestStruct{
			cid: 'bbb'
			name: 'bravo'
			description: 'second struct'
		},
		TestStruct{
			cid: 'ccc'
			name: 'charlie'
			description: 'third struct and english name'
		},
		TestStruct{
			cid: 'ddd'
			name: 'delta'
			description: 'displacement symbol'
		},
		TestStruct{
			cid: 'd00'
			name: 'delta'
			description: 'displacement symbol'
		},
	]

}

fn test_cid_name_find() ! {
	list := generate_list()
	mut i := cid_name_find[TestStruct](list, 'aaa')!
	assert i == 0

	i = cid_name_find[TestStruct](list, 'bbb')!
	assert i == 1

	i = cid_name_find[TestStruct](list, 'ccc')!
	assert i == 2

	i = cid_name_find[TestStruct](list, 'alpha')!
	assert i == 0

	i = cid_name_find[TestStruct](list, 'bravo')!
	assert i == 1
	
	i = cid_name_find[TestStruct](list, 'charlie')!
	assert i == 2
	
	if j := cid_name_find[TestStruct](list, 'delta') {
		assert false
	} else {
		assert err.msg == 'Duplicate root objects found.'
	}
	
}