This is what needs to be re-developed for other languages, we kept it as easy as possible. You will find logic bound to clients here. This includes functions to submit jobs, wait for them or even schedule them. 

Keep in mind that there can be more then one client per system. A client doesn't have to be an actor, it can be an entity that triggers jobs and waits for the result.

The client uses a couple redis queues:
* jobs.db
* jobs.processor.in
* jbos.return.$guid

### jobs.db
This is an hset where we keep the jobs. The keys are the guids, the values the json serialized job.

### jobs.processor.in
This is how we tell the processor to start processing jobs. First, we add the job to the db and then add the guid to this queue. The processor will notice this and take action on it. 

### jobs.return.$guid
Once the job has been put into the queue *jobs.processor.in* the client can wait for jobs to finish. He or she should look into the queue *jobs.return.$guid* for that. The processor will put the finished job into that queue once it is finished.
