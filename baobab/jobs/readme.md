# Action Jobs

## the serialized format

```


```

## model: Job

this is what needs to be re-developed for other languages, we kept it as easy as possible

```json
ActionJobPublic {
	guid         string 	//unique jobid (unique per actor which is unique per twin)
	twinid		 u32        //which twin needs to execute the action
	action   	 string 	//actionname in long form includes domain & actor
	args       	 Params     //see params below
	result       Params
	state        string     //see state below
	start        i64		//epoch
	end          i64		//epoch
	grace_period u32 		//wait till next run, in seconds
	error        string		//string description of what went wrong
	timeout      u32 		//time in seconds, 2h is maximum
	src_twinid	 u32    	//which twin was sending the job
	src_action   string		//unique actor id, runs on top of twin
	dependencies []string	//list of guids we need to wait on
}
```

the state:

```json
ActionJobState {
	init
	tostart
	recurring
	scheduled
	active
	done
	error
}
```

## Params

the following format can have spaces, be indented, the order is not important either

see crystallib.params for more information

```
description:something\\nyes
id:a1
name:\'need to do something 1\'
name10:\'this is with space\'
name11:aaa11
name2:test
name3:hi
name4:aaa
name5:aab
name6:aaaaa
```

if used inside action then it needs to be indented

\n means an enter, can also do multiline

## there can be more than 1 client

- when a client registers it choses a name
- the client for information purposes also populates a hset with actor coordinates (domain.actor.method) can be e.g. only domain or domain + actor or even domain + actor + method (just put in hset)
  - this is used by the RMBprocessor to route what needs to be done by the actor
  - the client needs to specify the queue names on which the client listens
- I can also work as client, not being an actor, just a client
