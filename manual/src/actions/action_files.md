# action_files

is a file which has actions defined example

```js
//select the book, can come from context as has been set before
//now every person added will be added in this book
!!book.select name:e6

//delete everything as found in current book
!!people.person_delete cid:1g

!!people.person_define
  //is optional will be filled in automatically, but maybe we want to update
  cid: '1g' 
  //name as selected in this group, can be used to find someone back
  name: fatayera 
	firstname: 'Adnan'
	lastname: 'Fatayerji'
	description: 'Head of Business Development'
  email: 'adnan@threefold.io,fatayera@threefold.io'

!!people.circle_link
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

!!people.digital_payment_add
    person:fatayera
	name: 'TF Wallet'
	blockchain: 'stellar'
	account: ''
	description: 'TF Wallet for TFT' 
	preferred: false
```
