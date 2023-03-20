module country

[heap]
pub struct CountryPointer {
pub mut:
	name        string
	cca2        string
	cca3        string
	ccn3        int
	vat_percent int = 20 // 0-100
	countries   &Countries [str: skip] // make sure is not dumped as json
}

// return the Country full info
pub fn (mut cp CountryPointer) detail() !Country {
	// use Countries.get
	return Country{}
}
