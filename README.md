# Noted2Xero

This is an educational Rust project for a (small) real live problem using as many components for a full developer/deploy/production 
pipeline.  
The problem is converting a CSV report file (from a program called noted) to a xero invoice import format. A very basic problem
that is a good learning ground for learning Rust.

# The project

## Code
This project is workspace split in three functional modules: 
- Core
- Web
- CLI 
Connected by a Rust workspace and an virtual workspace file (POM type Maven equivalent)

This project is a showcase for the usage of Rust as a project language and its integration into a DevOps pipeline.

This contains: 
- The code projects in workspace modules
- Run tasks in make file
- Build and run in containers 

To be added: 
- Deploy pipeline


# Get started 

Install the stack: 
- Rust (nightly build 1.53-nightly+) 
- Visual code (1.55+) or CLion (2021.1+) with the rust plugin installed.  
- Docker (2.10.6+)
- Docker Compose (1.29.x+)

# Components 

## Web 
Needs the nightly build of the Rust stack

```bash 
rustup override set nightly
```


# Security

## Containers
Scan for sec issues by for instance
You need to be logged in to the docker hub


```
docker login
...
docker scan --accept-license -f deploy/builder/Dockerfile_arm docker.io/phiroict/noted2xero_web:0.2.0_arm
```

## Code 

Check code quality with Clippy and rustfmt: 

```bash
rustup component add clippy 
# In the root of the workspace. 
cargo clippy

rustup component add rustfmt
cargo fmt
```

## CI
Looking at github action