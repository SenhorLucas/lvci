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

We first need to setup the Gerrit container by running the `init` command. Open
the `compose.yaml` file and uncomment the `command:` line in the Gerrit service,
then run:

    docker compose up gerrit

The container starts, runs the `init` command, and stops. Then comment out the
`command:` line in the `gerrit` service again.

Next, bring up service and the runner provider:

    docker compose up

Access the Jenkins server at `localhost:8080` and the Gerrit server at
`localhost:8081`.

To start and stop the containers without removing them:

    docker compose stop

And to stop the containers and remove them:

    docker compose down

If you want to throw away all the Jenkins data (pipelines, etc.), and the Gerrit
data, you should also delete the volumes with:

    docker compose down -v

## How Jenkins is configured

The Jenkins server is based on the [`jenkins/jenkins`] Docker image. This image is
further customized in the `jenkins-lv` Dockerfile.

The instance is configured with the [JCasC] plugin (configuration as code). The
configuration file lives under `jenkins-config/jenkins.yaml`.

Further reading:

- https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-job-configuration-using-job-dsl

## How Gerrit is configured

The Gerrit service is based on the `gerritcodereview/gerrit` Docker image.

## Create a dummy project

The reason we are doing all this is to be able to perform automated tasks when
things happen in our project. So well we need a project.

1. Create SSH keys

    ssh-keygen -t ed21519 -f ~/.ssh/gerrit-local -C 'Gerrit local'
    ssh-add ~/.ssh/gerrit-local

2. On the Gerrit UI, paste your public key in the SSH keys under Gerrit settings
3. Create a repository and clone it locally. We can do whatever we want with it
   for our testing purposes.

## Create a pipeline

1. Create a repository named `pipelines`, where your pipelines will live. This
   repository name is currently hard-coded in `jenkins.yaml`.
2. Clone the `pipelines` repository locally.
3. Create a `myjob.groovy` file, commit and push it.
4. Run the seed job on Jenkins
5. Tadaaa! Your new pipeline appears. On the Jenkins interface.


## Listening to events

TBC

[installing Docker Compose]: https://docs.docker.com/compose/install/
[`jenkins/jenkins`]
