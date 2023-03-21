module people

// Data Struct, DB in memory, over time will be cut in pieces and prob moved to more actor paradigm but ok for now
[heap]
pub struct PeopleDB {
pub:
	bid string 		// id of the book
	filter []string // how to sort & filter
	actor  string
pub mut:
	persons  	[]Person
	contact 	[]Contact
	circles 	[]Circle
}

// creates a new book data structure
pub fn db(bid string) PeopleDB {
		
	mut d := PeopleDB{
		//TODO: does this work for people.circle_delete... as well?
		filter: ['circle_delete', 'person_delete', 'circle_define', 'person_define', 'circle_link','circle_comment', 'digital_payment_add']
		actor: 'people'
		bid: bid	
	}
	return d
}
