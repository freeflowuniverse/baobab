module company

import freeflowuniverse.baobab.modelbase
import freeflowuniverse.crystallib.actionsparser
import freeflowuniverse.crystallib.params {Params}
import freeflowuniverse.baobab.modelbase {SmartId}

// company structure
pub struct Company {
	modelbase.BaseNamed		
pub mut:
	circles []SmartId // link to circles
	// registration_country  &country.Country
	// budget                &budget.Budget
}


fn (mut db CompanyDB) process_company(actions []actionsparser.Action) ! {
	//TODO: filtersort
	// cid := action.params.get('cid')!	
	panic("implement")

}


