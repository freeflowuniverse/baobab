module company

import freeflowuniverse.baobab.modelbase

[heap]
pub struct VatPolicy {
	modelbase.Base	
pub mut:
	cid            string 
	name           string
	description    string
	vat_percent    int  //0...100
	vat_return_months int //0... does the state return your VAT and how many months after having paid for the good
	// country        &country.Country // This might change to enum or custom struct
}
