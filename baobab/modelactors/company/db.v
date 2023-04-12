module company

import freeflowuniverse.baobab.utils
import freeflowuniverse.crystallib.currency  
import freeflowuniverse.crystallib.actionsparser

// Data Struct, DB in memory, over time will be cut in pieces and prob moved to more actor paradigm but ok for now
[heap]
pub struct CompanyDB {
pub:
	bid    string   // id of the book
	filter []string // how to sort & filter ???
	actor  string
	basecurrency &currency.Currency
pub mut:
	companies []Company
	vatpolicies []VatPolicy
	revenuepolicies []RevenuePolicy
	budget_revenue_items []RevenueItem
	budget_cost_items []CostItem
	budget_hr_items []HRItem
}

// creates a new book data structure
pub fn db(bid string, basecurrency string) !CompanyDB {
	mut currencies:=currency.new()!
	curr:=currencies.currency_get(basecurrency)!
	mut db := CompanyDB{
		filter: ['company_delete', 'budget_delete', 'company_define', 'budget_define'] 
		actor: 'company'
		bid: bid
		basecurrency: &curr
	}
	return db
}


// the company db will be filled in with all found relevant information
pub fn (mut db CompanyDB) process(actions actionsparser.Actions) ! {
	db.process_cost(actions)!
	db.process_company(actions)!
}

	// println('args: $args.path')
	// parser := actionsparser.new(
	// 	text: args.text
	// 	path: args.path
	// 	defaultactor: db.actor
	// 	defaultbook: db.bid
	// )!



pub fn (db CompanyDB)cid_new() string {
	for {
		mut cid := utils.random_id()
		//TODO: fix cid new
		// if db.persons.any(it.cid == cid) {
		// 	continue
		// }
		// if db.contacts.any(it.cid == cid) {
		// 	continue
		// }
		// if db.circles.any(it.cid == cid) {
		// 	continue
		// }
		return cid
	}
	return '' // todo: handle error
}

// type RootObject = Person | Contact | Circle // TODO: sym types 

pub fn (db CompanyDB) get(cid string) ?&RootObject {
	// person := db.persons.filter(it.cid == cid)
	// if person.len == 1 {
	// 	return &person[0]
	// }
	// contact := db.contacts.filter(it.cid == cid)
	// if contact.len == 1 {
	// 	return &contact[0]
	// }
	// circle := db.circles.filter(it.cid == cid)
	// if circle.len == 1 {
	// 	return &circle[0]
	// }
	return none
}

// TODO: getters for different objects

// pub fn (db CompanyDB) get_circle(cid string) ?&Circle {
// 	circles := db.circles.filter(it.cid == cid)
// 	if circles.len == 1 {
// 		return &circles[0]
// 	}
// 	return none
// }