# Initial thoughts
From the "Your task" part of the assignment I gathered that we are dealing with two tasks. One would be to move the avatars from one bucket to another. The second task is to update the references in the database.

From the "Example" I see that only the avatar key should be stored in the database. I interpret that is if the key begins with "image/" the avatar is read from the Legacy bucket and if it begins with "avatar/" it's read from the Modern bucket.

# Approach
The overall approach was doing a bit of local testing, implementing a POC and then implementing the actual application.

I wanted to build a proper way to test, so I thought I'd implement the infrastructure as code and build the avatar serving service before focusing on the tasks mentioned in the test.

# Options
There's basically two ways to handle the two tasks.

A. Copy all avatars from one bucket to the other and then update all database references

B. Copy one avatar and update its database reference

I favor options B. We can start small and if everything goes smoothly we can increase the throughput.

# Setup

## Infrastructure
Terraform is used to deploy the infrastructure which basically consists of an Api gateway, two Lambda's and a database.

## Avatar API
Micronaut, along with Kotlin, is used to implement a simple rest API for serving avatars.

A good entry point for this part of the application is the rest controller which can be found [here](https://github.com/tonsV2/sketch-avatar-api/blob/master/src/main/kotlin/sketch/avatar/api/controller/AvatarController.kt).

## Worker
Again Micronaut and Kotlin is used to implement a task which will pull from a queue and possible process asynchronously

A good entry point for this part of the application is the request handler which can be found [here](https://github.com/tonsV2/sketch-avatar-api/blob/master/src/main/kotlin/sketch/avatar/api/handler/LegacyToModernRequestHandler.kt).

# Testing
The way I usually test a restful service is by having some high level end to end testing which ensures that everything works as intended if accessed by a client. This covers testing of the view layer and is done [here](https://github.com/tonsV2/sketch-avatar-api/blob/master/src/test/kotlin/sketch/avatar/api/controller/AvatarControllerTest.kt).

The application layer is tested using unit tests where I mock the underlying services. Which means when I test the `AvatarService` I mock the `AvatarRepository` and other used services. This can be seen [here](https://github.com/tonsV2/sketch-avatar-api/blob/master/src/test/kotlin/sketch/avatar/api/service/impl/AvatarServiceImplTest.kt).

The data access layer is tested using an in-memory database, and the test can be found [here](https://github.com/tonsV2/sketch-avatar-api/blob/master/src/test/kotlin/sketch/avatar/api/repository/AvatarRepositoryTest.kt).

# Performance
We don't do any heavy calculations so data access is the bottleneck of our application.

If we were dealing with read intensive operations we could simply add more replicas and balance the queries across the replicas in a round robin fashion.

But we don't read a lot either, which brings us to writing. Disk writes, whether it's done by database updates or S3 puts, is our bottleneck. Our SQL queries is already as simple as can be, so here isn't much optimizing we can do.

The scalability of S3 is out of our hands so basically we're left with two options. Use bigger hardware for the database instance (and/or cluster it) and queue up our writes.

The latter option mentioned above is exactly what I've done in this application. I queue the tasks and thereby is able to scale up by adjusting `lambda_worker_reserved_concurrent_executions`, `batch_size` and `max_connections`.

The above mentioned configurations can be found in [vars-lambda_worker.tf](vars-lambda_worker.tf) and [vars-database.tf](vars-database.tf).

# Shortcomings
* I'm well away that I'm well aware I'm not doing RDS authentication right! Ideally I should generate a token client side and auth using that. But this needs to be enabled on the database server. So I either I need to expose it publicly or access it from a bastion node, at least that's the only ways I found while investigating

* Error handling is missing in several places. If you post an avatar with a non-unique key the API will return "500 Internal Server Error" which should obviously be handled more graceful

* For a real life project I would have created a project for the api, a project for the worker and a library for their shared business logic. Meaning all the code below the controller, and the handler, would reside in a business logic library

* CICD - At a minimum tests should be run at every git push

* When you walk in a production environment you better tread lightly and for this reason I do not delete avatars from the legacy bucket. The way I would go about a task like this would be to create a "Delete legacy bucket" ticket/task/jira and put it in the backlog for next month. This will ensure that everything actually did go as smoothly as assumed and further more we'd be able to see if any writes to the bucket has been done recently, so we ensure that no other system is actually using this bucket before deleting it

* I don't use terraform modules and I should

# Conclusion
I ended up spending a lot longer on this project than I anticipated. I hadn't touch AWS for more than two years, I had close to no experience with Lambda's and hadn't used Micronaut's serverless framework before.

I still believe the chosen tools are a got fit for a task like this and it was fun implementing it (despite hitting some bugs and the AWS outage).

I don't consider this a production ready solution. There's still several things which should implemented and more extensive testing would be necessary but due to the limited amount of funding dedicated to this project I'm unable to perform further testing.
