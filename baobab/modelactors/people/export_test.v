module people

struct TestStruct {
	mut:
	cid string
	firstname string
	lastname string
	num int
}

fn test_export_generic() {
	contact := TestStruct{
		cid: 'aaa'
		firstname: 'test'
		lastname: 'last'
		num: 3
	}

	str := export[TestStruct](contact)
	panic(str)
}

fn test_export_contact() {

	contact := Contact{
		cid: 'aaa'
		firstname: 'test'
		lastname: 'last'
		description: 'Head of Business Development'
		emails:      [Email{addr:'adnan@threefold.io,fatayera@threefold.io'}]
		tel:         [Tel {}]
		addresses:   []
	}
	assert contact.export() == "
	!!!delete_contact cid:'aaa'
	
	!!!define_contact 
		cid: 'aaa'
		firstname:'test'
		lastname:'last'
		description: 'Head of Business Development'
  		email: 'adnan@threefold.io,fatayera@threefold.io'
	"
}

fn test_export_people() {

	person := Person {
		cid: '2dm' 
		name: 'fatayera'
	}
	// assert contact.test() == "
	// !!!delete_person cid:'2dm'
	
	// !!!define_person 
	// 	cid: '2dm'
	// 	name: 'fatayera'
	// "
}

fn test_export_circle() {

	circle := Circle {
		cid: 'tt0' 
		name: 'tftech'
		description: 'Developing planet first people first tech'

	}
	// assert contact.test() == "
	// !!!delete_circle cid:'tt0'
	
	// !!!define_person 
	// 	cid: 'tt0'
	// 	name: 'tftech'
	// 	description: 'Developing planet first people first tech'
	// "
}