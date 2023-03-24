module utils

struct TestStruct {
	id string
	name string
	description string
}

fn generate_list() []TestStruct {
	return [
		TestStruct{
			id: 'aaa'
			name: 'alpha'
			description: 'first struct'
		}, 
		TestStruct{
			id: 'bbb'
			name: 'bravo'
			description: 'second struct'
		},
		TestStruct{
			id: 'ccc'
			name: 'charlie'
			description: 'third struct and english name'
		},
	]

}

fn test_find() {
	list := generate_list()

	config := FindConfig{
		fields: ['id', 'name', 'description']
		keyword: ''
		relevance: 10
	}
	
	// test find aaa
	mut search := TestStruct {
		id: 'aaa'
	}
	mut result := find(list, search, config) or {[99]}
	assert result[0] == 0
	assert list[result[0]].id == 'aaa'
	
	// test find bbb
	search = TestStruct {
		id: 'bbb'
	}
	result = find(list, search, config) or {[99]}
	assert result[0] == 1
	assert list[result[0]].id == 'bbb'

	// test find bb
	search = TestStruct {
		id: 'bb'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 1
	assert list[result[0]].id == 'bbb'

	// test find aaa by name
	search = TestStruct {
		name: 'alpha'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 0
	assert list[result[0]].id == 'aaa'

	// test find bbb by name
	search = TestStruct {
		name: 'bravo'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 1
	assert list[result[0]].id == 'bbb'

	// test find bbb by incomplete name
	search = TestStruct {
		name: 'bra'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 1
	assert list[result[0]].id == 'bbb'

	// test find ccc by incomplete name
	search = TestStruct {
		name: 'char'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 2
	assert list[result[0]].id == 'ccc'

	// test find aaa by description
	search = TestStruct {
		description: 'first struct'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 0
	assert list[result[0]].id == 'aaa'

	// test find ccc by incomplete description
	search = TestStruct {
		description: 'english'
	}
	result = find(list, search, config) or {[99]}
	// panic(result)
	assert result[0] == 2
	assert list[result[0]].id == 'ccc'

	// test find aaa by keyword
	mut config2 := FindConfig{
		fields: ['id', 'name', 'description']
		keyword: 'aaa'
		relevance: 10
	}

	result = find(list, search, config2) or {[99]}
	assert result[0] == 0
	assert list[result[0]].id == 'aaa'

	// test find aaa by keyword in description
	config2 = FindConfig{
		fields: ['id', 'name', 'description']
		keyword: 'first'
		relevance: 10
	}

	result = find(list, search, config2) or {[99]}
	assert result[0] == 0
	assert list[result[0]].id == 'aaa'
}