## Format

Below you can find an example of an action. As you can see it starts with the characters *!!* folowed by the domain, the actorname and the method. After that it contains all the parameters for that action separated by a space. Parameters are formatted as *attributename:attributevalue*. You can also pass flags by leaving the colon and the attribute value.

```
!!domain.actorname.method attribute1:value1 flag1 attribute2:value2 flag2
```

Formatting the action as shown below results in the same behavior.
```
!!domain.actorname.method
    attribute1:value1
    flag1
    attribute2:value2
    flag2
```

### Parameters

Baobab can parse many types of parameters:
- Number: 
- Text:
- Time:
- List of text or numbers:
- Paths:
- Boolean: 

If the value of a parameter exceeds one line you can always surround it with ''.

### comments

comments can be used but not at end of line, at start of line starting with # or //
