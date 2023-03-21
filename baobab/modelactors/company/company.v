module company

// import freeflowuniverse.baobab.modelactors.budget
// import freeflowuniverse.baobab.modelglobal.country

// company structure
pub struct Company {
pub mut:
	name    string
	circles []string // link to circles
	// registration_country  &country.Country
	// budget                &budget.Budget
}

//? In this case is it best to input full name and search data.people for that name?

pub struct CompanyNewArgs {
pub mut:
	name string
	// circles               map[string]&Circle
	// registration_country  &country.Country
}

// pub fn (mut company Company) budget_create () &budget.Budget {
// 	budget := budget.Budget{}
// 	company.budget = &budget
// 	return &budget
// }
