module company

import freeflowuniverse.baobab.modelbase
import freeflowuniverse.crystallib.actionsparser
import freeflowuniverse.crystallib.params {Params}
import freeflowuniverse.baobab.modelbase {SmartId}

// company structure
pub struct Company {
	modelbase.BaseNamed		
pub mut:
	name string
	circles []SmartId // link to circles
	budgets []SmartId
	// registration_country  &country.Country
}


fn (mut db CompanyDB) process_company(actions []actionsparser.Action) ! {
	//TODO: filtersort
	// cid := action.params.get('cid')!	
	panic("implement")

}



fn (mut obj Company) wiki() !string {
	return "IS WIKI"
}

