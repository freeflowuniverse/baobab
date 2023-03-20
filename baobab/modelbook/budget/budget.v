module budget

import freeflowuniverse.baobab.modelbook.people

// budget
// This file deals with the main budget item

[heap]
pub struct Budget {
pub mut:
	allocation []BudgetAllocation
	planning   []BudgetItem
	months     []BudgetMonth
}

type BudgetAllocation = BudgetAllocationPerson //| BudgetAllocationCompany
type BudgetItem = BudgetItemGeneric | BudgetItemOffice | BudgetItemPerson

// pub struct BudgetAllocationCompany{
// pub mut:
// 	start time.Time
// 	nrmonths int = 60
// 	company &organization.Company
// 	percentage int //0-100
// }

pub struct BudgetAllocationPerson {
pub mut:
	person     &people.Person
	percentage int // 0-100
}
