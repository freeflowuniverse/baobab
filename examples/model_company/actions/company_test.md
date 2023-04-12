
# testdata for creation of a company


```js

//select the book, can come from context as has been set before
//now every person added will be added in this book
!!actor.select aaa.company

//delete everything as found in current book
!!company_delete cid:1gt

!!company_define
  //is optional will be filled in automatically, but maybe we want to update
  cid: '1gt' 
  //name as selected in this group, can be used to find someone back
  name: threefold

!!company_tax_link
  company: '1gt' //can also be name  
  taxpolicy:'be'

!!company_comment cid:'1gt' 
    comment:
      this is a comment
      can be multiline 

!!taxpolicy_define
  name: 'be' 
  vat_percent:21.5
  vat_return_months:4

```
  
we also link the company to a default tax policy

// TODO: check parse, do we parse this as well in the code block, I think so, it should

