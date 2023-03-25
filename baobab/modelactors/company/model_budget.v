module budget

import freeflowuniverse.baobab.modelbase
// import freeflowuniverse.baobab.modelactors.finance
// import freeflowuniverse.baobab.modelglobal.country
import freeflowuniverse.crystallib.timetools { time_from_string }
import freeflowuniverse.crystallib.params { Tags TagsFilter}
import time

// budget_item
// This file deals with the budget item base and...

// URGENT: see crylstallib/params/tags.v  need to implement the tags

[heap]
pub struct CostItem {
	modelbase.Base			
pub mut:
	// budget_item_type BudgetItemType
	id             int
	name           string
	remark         string
	// country        &country.Country
	start          time.Time
	stop           time.Time
	vatpolicy	   &VatPolicy
	cost_policy	   &CostPolicy
	cost     f64	 //if cost policy then this one needs to be empty, is always in currency of the model
	cost_min f64
	cost_max f64
	category CostCategory
	tags Tags
}

pub enum CostCategory {
	software
	license
	other
}

pub struct BudgetItemGeneric {
	BudgetItemBase
pub mut:
	generic_type GenericType
}

pub struct ItemAddArgs {
	name         string
	remark       string
	start        string
	stop         string
	cost_month   string // fixed monthly - USD
	country      &country.Country
	generic_type string
	vat_extra    string = '0 USD'
}

//+1d, (d,h,m,y) or yyyy:mm:dd
//? how do you add error handling into this?
pub fn (mut budget Budget) item_add(args ItemAddArgs) !&BudgetItemGeneric {
	mut id := 1
	if budget.planning.len != 0 {
		id = budget.planning.last().id + 1
	}

	generic_type := match args.generic_type {
		'software' { GenericType.software }
		'license' { GenericType.license }
		'other' { GenericType.other }
		else { panic(error('Failed to parse inputted generic_type: Please enter either software, license or other.')) }
	}

	cost_fixed := finance.amount_get(args.cost_month)

	vat_extra := finance.amount_get(args.vat_extra)
	mut vat_percent := f64(0)
	if vat_extra.val != 0 {
		vat_percent = (100 * finance.amount_get(args.vat_extra).val / cost_fixed.val)
	}

	item := BudgetItemGeneric{
		id: id
		name: args.name
		remark: args.remark
		start: time_from_string(args.start) or {
			return error('Failed to get time from start string: ${args.start}')
		}
		stop: time_from_string(args.stop) or {
			return error('Failed to get time from stop string: ${args.stop}')
		}
		cost_fixed: cost_fixed
		cost_fixed_min: cost_fixed
		cost_fixed_max: cost_fixed
		country: args.country
		generic_type: generic_type
		vat_extra: vat_extra
		vat_percent: vat_percent
	}

	budget.planning << item

	return &item
}
