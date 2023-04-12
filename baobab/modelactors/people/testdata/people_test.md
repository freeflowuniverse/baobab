```yaml
//select the book, can come from context as has been set before
//now every person added will be added in this book
!!select_book aaa
!!select_actor people

!!contact_delete cid:8ed

//delete everything as found in current book
!!person_delete cid:1gt

!!contact_define
  //is optional will be filled in automatically, but maybe we want to update
  cid: '1gt' 
  //name as selected in this group, can be used to find someone back
	firstname: 'Adnan'
	lastname: 'Fatayerji'
	description: 'Head of Business Development'
  email: 'adnan@threefold.io,fatayera@threefold.io'

!!person_define
  //is optional will be filled in automatically, but maybe we want to update
  cid: '2dm' 
  //name as selected in this group, can be used to find someone back
  name: fatayera


!!person_link_contact
  contact: '1gt'
  person: 'fatayera'

!!circle_delete cid:tt0

!!circle_define
  //is optional will be filled in automatically, but maybe we want to update
  cid: 'tt0' 
  name: tftech
  description: 'Developing planet first people first tech'

!!circle_link
//can define as cid or as name, name needs to be in same book
  person: '1gt'
  //can define as cid or as name
  circle:tftech         
  role:'stakeholder'
	description:''
  //is the name as given to the link
	name:'vpsales'        

!!people.circle_comment cid:'1g' 
    comment:
      this is a comment
      can be multiline 

!!circle_comment cid:'1g' 
    comment:
      another comment

!!digital_payment_add 
  person:fatayera
	name: 'TF Wallet'
	blockchain: 'stellar'
	account: ''
	description: 'TF Wallet for TFT' 
	preferred: false

!!select_actor test

!!test_action
	key: value

!!select_book bbb

!!person_define
  cid: 'eg'
  name: despiegk

```