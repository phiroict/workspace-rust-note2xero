# Noted2Xero

This is a more advanced structure than the original project git@github.com:phiroict/arletta-noted2xero-converter-rust.git

This project is workspace split in three functional modules: 
- Core
- Web
- CLI 

# Components 

## Web 
Needs the nightly build of the Rust stack

```bash 
rustup override set nightly
```


# Security

Scan for sec issues by for instance
You need to be logged in to the docker hub


```
docker login
...
docker scan --accept-license -f deploy/builder/Dockerfile_arm docker.io/phiroict/noted2xero_web:0.2.0_arm
```