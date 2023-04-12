module company

import freeflowuniverse.baobab.modelbase
import freeflowuniverse.crystallib.timetools { time_from_string }
import freeflowuniverse.crystallib.params { Tags ParamsFilter}
import freeflowuniverse.crystallib.actionsparser
import freeflowuniverse.crystallib.params {Params}
import time

// budget_item

[heap]
pub struct CostItem {
	modelbase.Base			
pub mut:
	start          time.Time
	stop           time.Time
	vatpolicy	   &VatPolicy
	cost_policy	   &CostPolicy
	cost     f64	 //if cost policy then this one needs to be empty, is always in currency of the model
	cost_min f64
	cost_max f64
	tags Params
}


fn (mut db CompanyDB) process_cost(actions []actionsparser.Action) ! {

	// cid := action.params.get('cid')!	
	panic("implement")

}