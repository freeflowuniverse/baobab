# baobab

<<<<<<< HEAD
It's always a good practice to make your software do one thing only and do it well. It usually results in less complex code that is easier to maintain. So instead of having one application that is able to do 5 totally different things it is better to develop 5 different applications. If an application needs the help of another it can always ask. This introduction is a basic decription of the [actor model principles](https://www.oreilly.com/library/view/scala-reactive-programming/9781787288645/8253d31d-ed61-46c3-8c69-9d49d8d8ab07.xhtml). The baobab repository was created to facilitate applying the actor model principles to your codebase.
=======
- [manual](https://freeflowuniverse.github.io/baobab)
- [developer documentation](https://freeflowuniverse.github.io/baobab/v)

## Intro

It's always a good practice to make your software do one thing only and do it well. It usually results in less complex code that is easier to maintain. So instead of having one application that is able to do 5 totally different things it is better to develop 5 different applications. If an application needs the help of another it can always ask. This introduction is a basic decription of the [actor model principles](https://www.oreilly.com/library/view/scala-reactive-programming/9781787288645/8253d31d-ed61-46c3-8c69-9d49d8d8ab07.xhtml). The baobab repository was created to facilitate applying the actor model principles to your codebase. 
>>>>>>> development_calc

## Documentation
If you want to know more about baobab make sure to through the documentation under [manual](manual/src/SUMMARY.md).

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

## Examples
You will find examples under [examples](examples/). Although they are not real use cases they show the capabilities of baobab. 

Here are some real life use cases:
- [farmerbot](https://github.com/threefoldtech/farmerbot)

## How to generate the documentation
You can generate the documentation by running the bash script doc.sh. This will generate the documentation under docs which you can open in your browser. It also generates the V manual under docs/V/. 
> bash doc.sh


## Rules
When working on this repository please follow these rules:
1) Create a branch if you need to modify things on the repository
2) Always add tests when implementing a new feature
3) Create a PR for merging your branch
4) Assign reviewer(s) to your PRs
5) Only merge if reviewers have approved and CI is green
6) Create the necessary documentation or modify existing documentation under [manual](manual/src/)

