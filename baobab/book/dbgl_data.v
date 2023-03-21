module modelglobal

import freeflowuniverse.baobab.modelglobal.country
import freeflowuniverse.baobab.modelglobal.twin
import freeflowuniverse.baobab.modelglobal.book
import time

// Data Struct
[heap]
pub struct DBGLData {
	Base
pub mut:
	countries country.Countries [str: skip]
}

// creates a new global data structure
pub fn new() DBGLData {
	mut d := DBGLData{}
	d.countries = countries_get()
	return d
}
