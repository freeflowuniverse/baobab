# baobab

It's always a good practice to make your software do one thing only and do it well. It usually results in less complex code that is easier to maintain. So instead of having one application that is able to do 5 totally different things it is better to develop 5 different applications. If an application needs the help of another it can always ask. This introduction is a basic decription of the [actor model principles](https://www.oreilly.com/library/view/scala-reactive-programming/9781787288645/8253d31d-ed61-46c3-8c69-9d49d8d8ab07.xhtml). The baobab repository was created to facilitate applying the actor model principles to your codebase. 

## Actor

An actor can be seen as an entity that is able to do some work and that can asynchronously communicate with other actors. It can ask any other actor for some information which it needs to do some other work. This is very much how we work together as human beings. We ask a colleague to do some work that we need in order to do our work. But we don't wait for the result until we actually need it.

The baobab repository contains an interface for an Actor that defines one function: execute. Upon exection this function basically tells the actor to execute a specific job (description of jobs will be given further down the document).

Baobab also provides you the means to execute jobs from another actor without having to know where the actor is running nor how to communicate with it. This is what we call the ActionRunner. It allows you to pass the a list of actors that you want to run on your system. It will know which actor should execute what job and it will initialize the execution of the job (send the job to the actor). The ActionRunner does that by maintaining a couple of redis queues and passing around jobs to the right queue. After the execution of the job it will return the response back to the actor that requested the execution. 

If you wish to implement an actor in another language you should recreate the Actor interface and implement the actors and implement the behavior of the ActionRunner also.

## Jobs

The word job has been mentioned a few times already in this document. One can describe a job as the information needed by an actor to do a specific thing (compute something, produce a specific result on a system, bring an actor in a specific state, etc). In baobab a job contains the attributes:
- guid: a unique job id
- twinid: the twinid of the system that contains the actor that can execute this job
- action: a name for the job which should be unique across all actors, it should follow the structure domain.actor.action
- args: the arguments that the actor requires in order to execute that job
- result: the result(s) that we expect to get once the job is executed
- state: the current state of the job
- error: in case something went wrong the error message
- timeout: the timeout for the job
- src_twinid: the twinid of the one requesting the execution of the job

## Processor

Baobab needs one more component in order to have a fully working actor model: the Processor. The Processor is in charge of moving the jobs to the right queues based on its state:
- if the job is in init state it will put it in the queue for the actionrunner to execute it
- if the timeout has execeeded it will return an error
- if the job resulted in an error it will return that error
- if the ActionRunner properly returned the job it will return it

## Jobs through RMB
The Processor is also in charge of initiating the executing of jobs that it received via RMB. This introduces one extra depencendy though: the system should be running the [rmb-peer](https://github.com/threefoldtech/rmb-rs/releases). 

To execute the job from another system you should send an RMB message with the [json stringyfied job](jobs/model_json.v) as payload to the twinid of the system that can execute the job. The command of the RMB message should be *execute_job*. The job will be returned with the results if everything went well.

## Dependencies
Baobab has the following dependencies:
- redis
- [crystallib](https://github.com/freeflowuniverse/crystallib)

## How to install baobab
As previously mentioned baobab has a dependency towards crystallib. You should therefore pull the repository and install it:
> git clone -b development https://github.com/freeflowuniverse/crystallib.git \
> cd crystallib \
> bash install.sh

Next you'll have to install baobab:
> bash install.sh

## How to run the tests
Now that you installed the V dependencies you can start running tests. The tests will use the redis running on port 6379 so make sure it is running before running the tests:
> sudo systemctl start redis-server

Now run the tests with this command (we cannot run tests in parallel so make sure to pass the environment variable VJOBS=1):
> VJOBS=1 v -stats test .

## Rules
When working on this repository please follow these rules:
1) Create a branch if you need to modify things on the repository
2) Always add tests when implementing a new feature
3) Create a PR for merging your branch
4) Assign reviewer(s) to your PRs
5) Only merge if reviewers have approved and CI is green
6) Create the necessary documentation or modify existing documentation

