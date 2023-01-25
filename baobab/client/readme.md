# Action Jobs

this is what needs to be re-developed for other languages, we kept it as easy as possible

## utilization in redis

```
//everyone uses
jobs.db  //key is guid in hset, the content is the value of the job json serialized
//processor writes, actionrunner listens
jobs.actors.$domain_name.$actorname   //is queue which tells actor there is something for you to do, returns guid
//processor uses, client polls the return to know RPC is done
jobs.return.${guid} //a queue per job, to wait for return (if we were asking for an action to be executed)
//client writes:
jobs.processor.in  //is queue for the job processor (job guid), to basically trigger the processor to make sure job will get executed
//actor writes (or actionrunner if timeout):
// ? inquire purpose
jobs.processor.result // once job executed put guid in this queue, the processor will do the test
jobs.processor.error  // once job executed adn in error put guid in this queue
//processor writes
jobs.processor.active // hset keeping a list of the active jobs, is just list of guid's
```

## there can be more than 1 client

- when a client registers it choses a name
- the client for information purposes also populates a hset with actor coordinates (domain.actor.method) can be e.g. only domain or domain + actor or even domain + actor + method (just put in hset)
  - this is used by the RMBprocessor to route what needs to be done by the actor
  - the client needs to specify the queue names on which the client listens
- I can also work as client, not being an actor, just a client
