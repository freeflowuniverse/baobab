
## special actions

### book select

select the book to operate in, is not always needed, can be that a textfile has been given already for a specific book

```js

!!book.select aaa
//also ok
!!book.select name:aaa
//also ok
!!book.select name:'aaa'
```

is all the same, this will force all actions coming after this one to be applied for that specific book.

### actor select

to make a shortcut to select a specific actor

```js

!!actor.select people

//or with book
!!actor.select aaa.people

//also ok
!!actor.select name:aaa.people

```

- the aaa is the id of the book and is pre-pended to argument
- note we use argument here not a named value

