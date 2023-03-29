module main

import freeflowuniverse.baobab.utils

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

fn main() {
	// list := generate_list()
	// search := TestStruct {
	// 	id: 'aaa'
	// }

	// config := utils.FindConfig{
	// 	fields: ['id', 'name', 'description']
	// 	keyword: ''
	// }

	// result := utils.find(list, search, config)
	// panic(result)
}