module budget

import freeflowuniverse.baobab.modelbase
import freeflowuniverse.crystallib.params {TagsFilter}

[heap]
pub struct CostPolicy {
	modelbase.Base	
pub mut:
	cid            string 
	name           string
	description    string
	tagsfilter   	TagsFilter 			//will define which parts of revenue or cost will be counted
	revenue_percent int  		//0...100
	cost_percent    int
	min_cost	    int
	max_cost	    int
}
