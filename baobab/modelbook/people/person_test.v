module people

import os
import freeflowuniverse.crystallib.pathlib

const data_file = os.dir(@FILE) + '/person_test.js'

fn test_person() {
	mut path_data := pathlib.get(people.data_file)
	data := path_data.read()!
	mut db := db('aaa')
	db.process(data)!
	println(db)
	panic('sss')
}
