# Noted2Xero

## Goal

This is an self taught Rust project for a (small) real live problem using as many components for a full developer/deploy/production 
pipeline.  Note that this is not an educational project, this is written by a beginner of the Rust language and may not in any way the preferred use of the language in many cases, this code will evolve as insights increase. Do not use this for school project and expect anything more than a D :) 

## What this solves
- The problem is converting a CSV report file (from a program called noted) to a xero invoice import format. A very basic problem
that is a good learning ground for learning Rust.
- It is also a segway into building a full stack Rust application and a discovery what is needed to get this to a reasonable standard. 

# The project

The project is aimed to be a full stack project, containing: 
- Source projects in several components in a central workspace
- A set of deploy targets mediated by make to build, check, deploy components
- A CI that is done by GitHub Actions.  __Note that this component needs extra configuration after cloning as this is linked to an account, the rest should run fine locally.__
## Code
This project is workspace split in three functional modules: 
- Core (Library - Has the shared structs and methods but has no interface)
- Web (Exe - stand alone web service based on the rocket framework)
- CLI  (Exe - standalone run once commandline executable, will start, transform the CSV and then exit)
  
Connected by a Rust workspace and an virtual workspace file (POM type Maven equivalent)
Both Web and CLI depends on the Core. 



# Get started 
## Clone this repo
This project consists out of a main git repo and three submodules. You need to checkout recursivly. 
```bash
git clone --recurse-submodules -j3 git@github.com:phiroict/workspace-rust-note2xero.git
```
(The -j3 means that the submodules are checked out in parallel, this function has been added in git 2.8. If you have an older version you need to remove that flag)

When cloning or forking the project you need to create your own submodules and point to these by updating the .gitmodules file and recreate the .git/modules by running 
`git submodule init` and then `git submodule update`. You may have to delete the .git/modules folder first to avoid conflicts. 


To be added: 
- Deploy pipeline to a production like system. At the moment it created the container and uploads it to dockerhub.

## Softeware stack
Install the stack: 
- Git (2.8+)
- Rust (nightly build 1.53-nightly+) 
- Visual code (1.55+) or CLion (2021.1+) with the rust plugin installed.  
- Docker (20.10.6+)
- Docker Compose (1.29.x+)
- Make (CMake) 
- gcc or the windows equivalent for those so inclined. (Visual Studio or MingGW)

## Hardware/OS stack 
This project has been developed on a Linux workstation with a Xenon Intel CPU and has been extended to run under the ARM Silicon Hardware stack (M1 CPU). Though it should work under windows with some adaptations. I have not attempted that. (Or planning to do so)
# Components 

## Web 
Needs the nightly build of the Rust stack, (`make init` will set this up for you) 
This runs the CSV converter as a web service, its entrypoint is 

```bash 
rustup override set nightly
```

Run the component by 
```bash
./noted2xero_web
```
Check out the `make run_web` target for more context. 


The web component will run until killed listening on port 8000 it expects a POST to http://YourHostHere:8000/noted with a form with `data` as the Noted CSV payload and `text` as the invoice number. 
An example web page is [at](./index.html)  

## CLI 
Can run both under nightly or standard rust release. This is a simple commandline that will look for a Noted CSV in the resources/notedfolder in the folder it is running from. It also expects the xerofolder and donefolder there. (See the `make init` for details)
You need to pass a parameter that is the first free invoice number available on the Xero account you want to import your invoices to.  For instance if INV-2999 is your latest invoice then: 
```bash
./noted2xero_cli 3000
```
See `make run_cli` for how it runs from this project. 


## Core 
This is a library that has the common shared structs and methods for the CLI and Web component. It has no further functionality or interfaces. 
## Make Targets

| Name | Goal |
| --- | --- |
|init | ENTRYPOINT PROJECT: Run this first! :: Creates ancillary folders and installs rust components we use,|
|check_code | Runs cargo fmt and clippy to detect code standard violations |
|build | Build a development version |
|check_container | Runs hadolint to check the Dockerfile for the web service |
|build_container | Builds the container |
|check_container_arm | Checks a container on the ARM platform to work with on the Metal hardware from Apple (M1 processor)|
|build_container_arm | Builds a container on the ARM platform to work with on the Metal hardware from Apple (M1 processor)|
|build_container_release | Build the release version of the container while creating a tag and update the version (NOT FUNCTIONAL YET)|
|version_cli | Update the version of the CLI (NOT FUNCTIONAL YET)|
|version_web | Update the version of the Web component (NOT FUNCTIONAL YET) |
|release | Builds the whole release pipeline and produces a web component in an image at the end |
|release-rc | Same as release but increases the version (NOT FUNCTIONAL YET) |
|run_cli | Runs the CLI of the app locally |
|run_web   |  Runs the web component locally |
|run_web_container | Runs the web container locally |
|run_web_container_arm | Runs the ARM version of the container locally |
|test | Runs the tests |
|deploy | Installs the cli through ansible to a target (NOT IMPLEMENTED YET) |
|run_stack | Runs the docker compose stack to offer a web frontend on the web service and the web service itself. |
|stop_stack | Stops the stack started with run_stack |


# Security

## Containers
Scan for sec issues by for instance
We use hadolint to check for security and coding standard issues in the Dockerfile we use to wrap the release of the web component. 
## Code 

Check code quality with Clippy and rustfmt: 

```bash
rustup component add clippy 
# In the root of the workspace. 
cargo clippy

rustup component add rustfmt
cargo fmt
```
The components have been added in the init make target, if you have not run it, you can install it yourself. 

A lot of the heavy lifting for security is done by Rust itself by disallowing any memory insecure actions by default.  The code has no secrets and the files itself are not stored or retained. 

# CI
Uses a github action for build and delivery into a docker project. 
Note that these run on commits to this repo, and will, by design, not work on forked repos, you need to create one yourself (based on `.github/workflows/blank.yml`) and create and fill
your own secrets with the same name. 


[![CI](https://github.com/phiroict/workspace-rust-note2xero/actions/workflows/blank.yml/badge.svg)](https://github.com/phiroict/workspace-rust-note2xero/actions/workflows/blank.yml)

## SECRETS 
When forking the project or just working from it you need to change a few things: 
- Point to you own dockerhub account
  - This means changing the references in the make file and in the build pipeline. 
- Create secrets for the Github actions, (these are not exported when forked for the obvious reasons.)
  - SUBMODULE_TOKEN    : This is github token you need to checkout the submodules if you choose to make these private.
  - DOCKERHUB_USERNAME : The username for the dockerhub you want to push the project to.
  - DOCKERHUB_TOKEN    : The token you have created on github for access, recommended it to give this token only access to the repo and nothing else.  


# Kubernetes 

The stack can be deployed to kubernetes, use the kustomize make tasks to deploy 

Note you need for this functionality 

- A Kubernetes cluster 
- An account to be able to deploy services, deployments, etc.
- the `kustomize` tool

## Dashboard
For convenience you can install the [dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) and go to it 
Set up the loadbalancer proxy by:

```bash
kubectl proxy
```
And navigate to it (grab the secret like the site described): 

`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`