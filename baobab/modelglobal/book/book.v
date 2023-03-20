module organization

import freeflowuniverse.baobab.modelbook.budget
import freeflowuniverse.baobab.modelglobal.country
import freeflowuniverse.baobab.modelbook
import freeflowuniverse.baobab.modelbase

// Book structure
pub struct Book {
	modelbase.Base
pub mut:
	bid  string // unique on regional internet level (3-6 letters, 5 letters give 50m, 6 letters give 1.8 billion)
	name string
}

//? In this case is it best to input full name and search data.people for that name?

[params]
pub struct BookNewArgs {
pub mut:
	name        string
	description string
	bid         string // unique on regional internet level (3-6 letters, 5 letters give 50m, 6 letters give 1.8 billion)
}

pub fn (mut Book Book) budget_new() &budget.Budget {
	budget := budget.Budget{}
	Book.budget = &budget
	return &budget
}
