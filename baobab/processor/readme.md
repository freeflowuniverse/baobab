# Processor

**Processor requires a redis server running at local port 6379**

### Redis Queues

The processor uses the following queues to allow messaging of ActionJob's between external clients and internal actors.

```
jobs.actors.$domain_name.$actorname //is queue which tells actor there is something for you to do, returns guid
//processor uses, client polls the return to know RPC is done
jobs.return.${guid} //a queue per job, to wait for return (if we were asking for an action to be executed)
//client writes:
jobs.processor.in //is queue for the job processor (job guid), to basically trigger the processor to make sure job will get executed
//actor writes (or actionrunner if timeout):
// ? inquire purpose
jobs.processor.result // once job executed put guid in this queue, the processor will do the test
jobs.processor.error // once job executed adn in error put guid in this queue
//processor writes
jobs.processor.active // hset keeping a list of the active jobs, is just list of guid's
```

### Testing

Make sure to have a redis server running at local port 6379 before running tests.

```

```
