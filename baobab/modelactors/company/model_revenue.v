module company

import freeflowuniverse.baobab.modelbase
import freeflowuniverse.crystallib.params {ParamsFilter}

[heap]
pub struct RevenuePolicy {
	modelbase.BaseNamed
pub mut:
	tagsfilter   	ParamsFilter 			//will define which parts of revenue or cost will be counted
	revenue_percent int  					//0...100, will have to be done recursively
	cost_percent    int
	min_cost	    int
	max_cost	    int
}
