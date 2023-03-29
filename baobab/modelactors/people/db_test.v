module people

fn test_db() {
	database := db('aaa')
	assert database == PeopleDB{
		bid: 'aaa'
		filter: ['circle_delete', 'person_delete', 'circle_define', 'person_define', 'circle_link', 'circle_comment', 'digital_payment_add']
		actor: 'people'
		persons: []
		contacts: []
		circles: []
	}
}
