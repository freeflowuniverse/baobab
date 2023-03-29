module people

pub fn (mut person Person) link_contact(contact &Contact) !&Person {
	person.contact = contact
	return person
}