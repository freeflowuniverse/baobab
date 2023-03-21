# People

- contact: in future to be filled in and maintained by each twin
- circle: group of persons
  - always linked to 1 book
  - a person is object representing a human being, but the content is unique for the twin it lives in, it can start from information as retrieved from another twin through the contact information

## Person

```js

//select the book, can come from context as has been set before
//now every person added will be added in this book
!!data.book.select bid:e6

//delete everything as found in current book
!!data.person.delete cid:1g

!!data.person.define
  cid: '1g' //is optional will be filled in automatically, but maybe we want to update
  name: fatayera //name as selected in this group, can be used to find someone back
	firstname: 'Adnan'
	lastname: 'Fatayerji'
	description: 'Head of Business Development'
  email: 'adnan@threefold.io,fatayera@threefold.io'

!!data.person.circle.link
  circle:tftech         //can define as cid or as name
  role:'stakeholder'
	description:''
	name:'vpsales'        //is the name as given to the link

!!data.person.circle.comment cid:'1g' 
    comment:'
      this is a comment
      can be multiline 
    '

!!data.person.circle.link 
  circle:tffoundation 
  role:'stakeholder'
	name:'ceo'

!!data.person.digital_payment.add 
  person:fatayera
	name: 'TF Wallet'
	blockchain: 'stellar'
	account: ''
	description: 'TF Wallet for TFT' 
	preferred: false
```

