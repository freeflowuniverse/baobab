module utils

// import freeflowuniverse.baobab.modelactors.company [Company]
// import freeflowuniverse.baobab.modelactors.people [Person,Contact,Circle]

// type RootObject = Company | Person | Contact | Circle

//talk to known actors local or remote to find the sid (smartid), can be in full form or partial
//it only works for supported types
fn  find_global[T](sid string) !T {
	// NEXT: implement find over actors local & remote, return the right rootobject if it exists
	//first version we can implement this by walking over all the local ones
	// can use this to e.g. find a Contact from local or other peoplemanager actor
	// an actor will return it e.g. as smarttext (actions) and we can import it that way into the generic type, or json???
}
