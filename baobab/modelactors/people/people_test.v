module people

import os
import freeflowuniverse.crystallib.pathlib

const data_file = os.dir(@FILE) + '/people_test.js'

fn test_datastructure() {
	mut db:=db()!
	db.process(path:data_file)!
	println(db)
	panic("test db for people") //TODO: add more items in file e.g. contact, ... play with other order so it still works

}
