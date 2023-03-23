## Format

Below you can find an example of an action. As you can see it starts with the characters *!!* folowed by the domain, the actorname and the method. After that it contains all the parameters for that action separated by a space. Parameters are formatted as *attributename:attributevalue*. You can also pass flags by leaving the colon and the attribute value.

```js
!!domain.actorname.method attribute1:value1 flag1 attribute2:value2 flag2
```

Formatting the action as shown below results in the same behavior.
```js
!!domain.actorname.method
    attribute1:value1
    flag1
    attribute2:value2
    flag2
```

### Parameters

Baobab can parse many types of parameters:
- Number: any type of number can be used here
- Text: any type of text can be used here
- Time: this represents a time value which can be 24 hour format or am/pm format. These are some valid examples: 21, 22:12, 10PM, 11:20PM, 3AM, 4:32AM
- Time interval: represents a start and stop time. The start and stop time should be joined by dash and the start time should be earlier than the end time. For example: 10:20-22:15 or 10:20AM-10:15PM
- List of text or numbers: a list should have its values joined by the comma character and the list should be surrounded by square brackets. Items in the list can be surrounded by single or double quote marks. Here is a valid example: [2,5,4,10] or [worda,wordb,wordc] or [worda, wordb, wordc] or even ["worda and b", "word c and d"]
- Path: this represents a path on the system. The validity of the path will be checked when parsing.
- Boolean: this represents boolean values. The values 0, n, no and false will all be recognized as false. The values 1, y, yes and true will all be recognized as true.
- Size in bytes, kilobytes, megabytes or gigabytes: this represent the size of files, hardware capacity, etc. The suffixes KB, MB and GB indicate that the values are in kilobytes, megabytes or gigabytes. If no such suffix is added the values are considered bytes.

If the value of a parameter exceeds one line you can always surround it with ''.

### comments

We also support comments but they cannot be used at the end of the file, only at the start of a line. The characters # and // represent the beginning of a comment. 
