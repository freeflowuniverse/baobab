module country

import freeflowuniverse.crystallib.pathlib

// the representation in nice V struct, has all info from Country Json
// uses sub structs
pub struct Country {
pub mut:
	countries &Countries [str: skip] // make sure is not dumped as json
}

// see https://restcountries.com/v3.1/all

// TODO: implement this functionality

pub fn (mut c Country) save(reset bool) ! {
	// store in datadir/$CCA2/ each country under CCA2 as key (name of sub dir)
	// check if the files e.g. flags are already under that subdir
	// if files are not in subdir, then download them
	// all files pointed to in json need to be downloaded
	// if reset then will re-download all
}
