module country

import freeflowuniverse.crystallib.pathlib

pub struct Countries {
pub mut:
	datadir   pathlib.Path // where we save the data of the countries
	countries map[string]&CountryPointer // cca2 as key
}

pub fn new(datadir pathlib.Path) !Countries {
	mut cs := Countries{
		datadir: datadir
	}
	// cs.countries=countries_get()!
	return cs
}

// https://restcountries.com/v3.1/all
pub fn (mut cs Countries) load(reset bool) ! {
	// parse json file
	// populate all CountryJson's	
	// store in datadir (use the save)

	// if reset true, then will re-download from internet
}

// get Country from local directory
pub fn (mut cs Countries) country_get(name string) !Country {
	return Country{}
}

// get CountryPointer from memory
pub fn (mut cs Countries) pointer_get(pointer string) !CountryPointer {
	// select based on different CCA2,CCA3, ...
	return CountryPointer{}
}
