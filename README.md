# CI sandbox

The goal is to be able to create a reasonably good test bed for CI workflows
based on Jenkins and Gerrit. The goals of this project are:

- Easy to bring the system up and down and test out new configurations
- Easy to test interactions between different serviced, e.g. whenever a tag is
  created on a Gerrit repository, a pipeline is run on Jenkins.

Such workflows are common place. Think about it. You want to do a release. The
best I know to release software is to mark a specific commit on the `master`
branch (a.k.a. `dec`, `trunk`, `main`) as the released content. That can be done
with a tag and/or a branch.

So we can simply push a new tag to a Git remote and Jenkins will "hear" that and
start the entire CI machinery to perform that release: be it running further
testing, copying binaries to a distribution location, updating the documentation
website, and so on.

Another common workflow is to perform tests on any commits pushed to a branch
that starts with `feature/` and upload a "test score" tag to the Git server. On
Gerrit that is the "Verified" vote, but GitHub, GitLab and others all have their
mechanisms.

This project does not intend to develop these mechanisms themselves, though. It
intends to provide an easy starting point for _you_ to develop your own.

## Getting started

Start by [installing Docker Compose] if you haven't yet.

Then bring up the Jenkins service and the runner provider:

    docker compose up

At this point you can browse to localhost:8080 to see your Jenkins instance. Go
ahead and try to create a pipeline that prints "Hello, world!" to the console.
Possible using both, declarative and procedural pipeline types to get a feel
for them.

Clicking around is not the way this project is intended to be used in the long
run, though, but this is what can be achieved without a Git server.

To start and stop the containers without removing them:

    docker compose stop

And to stop the containers and remove them:

    docker compose down

If you want to throw away all the Jenkins data (pipelines, etc.), you should
also delete the volumes with:

    docker compose down -v

## The Jenkins configuration

The Jenkins server is based on the [`jenkins/jenkins`] Docker image. This image is
further customized in the `jenkins-lv` Dockerfile.

The instance is configured with the [JCasC] plugin (configuration as code). The
configuration file lives under `jenkins-config/jenkins.yaml`.

Further reading:

- https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-job-configuration-using-job-dsl


## Pipeline configuration

The idea is that pipelines will be configured automatically using a seed job
using the JobDSL Jenkins plugin. This is more easily done when we have a Git
server up and running, which isn't the case just yet.



[installing Docker Compose]: https://docs.docker.com/compose/install/
[`jenkins/jenkins`]
