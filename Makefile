init:
	cargo install cargo-bump
	mkdir -p noted2xero_cli/resources/donefolder
	mkdir -p noted2xero_cli/resources/notedfolder
	mkdir -p noted2xero_cli/resources/xerofolder
build:
	cargo build
version:
	cargo bump patch --git-tag
release: test
	cargo doc
	cargo build --release
	cp target/release/noted2xero .
release-rc: version release
release-windows: test
	cargo doc
	cargo build --release --target x86_64-pc-windows-gnu
run_cli:
	cargo run -p noted2xero_cli
test:
	cargo test
deploy: release
	cd deploy/ansible && ansible-playbook --connection=local deploy-notedfolder.yml
.PHONY: deploy