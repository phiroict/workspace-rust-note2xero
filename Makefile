N2X_VERSION ?= `bash get_web_version_from_toml.sh`
init:
	cargo install cargo-bump
	mkdir -p noted2xero_cli/resources/donefolder
	mkdir -p noted2xero_cli/resources/notedfolder
	mkdir -p noted2xero_cli/resources/xerofolder
build:
	cargo build
build_container:
	docker build -t phiroict/noted2xero_web:$(N2X_VERSION) -f deploy/builder/Dockerfile .
build_container_release: version_web build_container
version_cli:
	cd noted2xero_cli && cargo bump patch --git-tag
version_web:
	cd noted2xero_web && cargo bump patch --git-tag
release: test
	cargo doc
	cargo build --release
	cp target/release/noted2xero_cli noted2xero_command
	cp target/release/noted2xero_web noted2xero_web_service
	cp target/release/noted2xero_web deploy/container/noted2xero_web
	cd deploy/container && docker build -t phiroict/noted2xero_web:$(N2X_VERSION) .
release-rc: version release
release-windows: test
	cargo doc
	cargo build --release --target x86_64-pc-windows-gnu
run_cli: build
	cp target/debug/noted2xero_cli noted2xero_cli/
	cd noted2xero_cli && ./noted2xero_cli 3000
run_web: build
	cp target/debug/noted2xero_web noted2xero_web/
	cd noted2xero_web && ./noted2xero_web
run_web_container:
	docker run -d -p 8000:8000 phiroict/noted2xero_web:$(N2X_VERSION)
test:
	cargo test
deploy: release
	cd deploy/ansible && ansible-playbook --connection=local deploy-notedfolder.yml
.PHONY: deploy