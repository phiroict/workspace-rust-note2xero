# Noted2Xero

This is a more advanced structure than the original project git@github.com:phiroict/arletta-noted2xero-converter-rust.git

This project is workspace split in three functional modules: 
- Core
- Web
- CLI 

This project is a showcase for the usage of Rust as a project language and its integration into a DevOps pipeline.

This contains: 
- The code projects in workspace modules
- Run tasks in make file
- Build and run in containers 

To be added: 
- Deploy pipline


# Get started 

Install the stack: 
- Rust
- Visual code or CLion with the rust plugin installed. 
- 

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