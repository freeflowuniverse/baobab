module people

import os
import freeflowuniverse.crystallib.pathlib

const data_file = os.dir(@FILE) + '/testdata/people_test.md'

fn test_datastructure() {
	mut database := db("aaa")
	database.process(path: people.data_file)!
	println(db)
}