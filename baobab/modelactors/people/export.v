module people


//NEXT: export to wiki

import freeflowuniverse.crystallib.actionsparser

[params]
pub struct Export {
pub:
	path string // can be dir or file
}

// processes text or path for actions
// the people db will be filled in with all found relevant information
// params:
// 	text   string	//text to get the content from
// 	path   string   // can be dir or file
pub fn (mut db PeopleDB) export(args Export) {
	mut content := ''
	//export to path full structure in wiki format of this db (person, contact)
	content += db.export_contacts()
	content += db.export_persons()
	content += db.export_circles()
	// println(actions)
	if true {
		panic(content)
	}
}

pub fn (db PeopleDB) export_contacts() string{
	mut str := ''
	for contact in db.contacts {
		str += contact.export()
	}
	return str
}

pub fn (db PeopleDB) export_persons() string{
	mut str := ''
	for contact in db.contacts {
		str += contact.export()
	}
	return str
}
pub fn (db PeopleDB) export_circles() string{
	mut str := ''
	for contact in db.contacts {
		str += contact.export()
	}
	return str
}

pub fn (contact Contact) export() string {
	mut str := '!!!delete_contact
	cid: $contact.cid'

	str += '!!!contact_define'
	
	str += 'cid: $contact.cid'

	if contact.firstname != '' {
		str += 'firstname: $contact.firstname'
	}
	if contact.lastname != '' {
		str += 'lastname: $contact.lastname'
	}
	if contact.description != '' {
		str += 'description: $contact.description'
	}
	if contact.emails.len != 0 {
		str += 'emails: $contact.emails'
	}
	if contact.tel.len != 0 {
		str += 'tel: $contact.tel'
	}
		if contact.addresses.len != 0 {
		str += 'addresses: $contact.addresses'
	}
	return str
}


pub fn export[T](t T) string {
	mut str := ''
	$for field in T.fields {
		val := t.$(field.name)
		mut exported := ''
		$if field.typ is string {
			exported = export_string(val)
		}
		$else $if field.typ is int {
			exported = export_int(val)
		}
		$else $if field.is_array {
			exported = export_array(val)
		}
		if exported != '' {
			str += '$field.name: $exported\n'
		}
	}
	return str
}

// pub fn export_field[T](val T, field FieldData) string {
// 	mut exported := ''
// 	// val := t.$(field.name)
// 	panic(val)
// 	return ''
// 	// $if field.typ is string {
// 	// 	exported = export_string(val)
// 	// }
// 	// $else $if field.typ is int {
// 	// 	exported = export_int(val)
// 	// }

// 	// if exported == '' {
// 	// 	return ''
// 	// }

// 	// return '$field.name: $exported'
// }

pub fn export_string(str string) string {
	if str == '' {
		return ''
	}
	return "'$str'"
}

pub fn export_int(num int) string {
	if num == 0 {
		return ''
	}
	return '$num'
}

// pub fn export_array(num int) string {
// 	if num == 0 {
// 		return ''
// 	}
// 	return '$num'
// }