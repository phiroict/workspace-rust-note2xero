N2X_VERSION ?= $(shell bash get_web_version_from_toml.sh)
init:
	rustup override set nightly
	cargo install cargo-bump
	rustup component add clippy
	rustup component add rustfmt
	mkdir -p noted2xero_cli/resources/donefolder
	mkdir -p noted2xero_cli/resources/notedfolder
	mkdir -p noted2xero_cli/resources/xerofolder
	sudo systemctl start docker
check_code:
	cargo clippy
	cargo fmt
	cargo test
build: check_code
	cargo build
check_container: check_code
	docker run --rm -i hadolint/hadolint <  deploy/builder/Dockerfile
build_container: check_code check_container
	docker build -t phiroict/noted2xero_web:$(N2X_VERSION) -f deploy/builder/Dockerfile .
check_container_arm: check_code
	docker run --rm -i hadolint/hadolint <  deploy/builder/Dockerfile_arm
push_container:
	docker push phiroict/noted2xero_web:$(N2X_VERSION)
push_container_arm:
	docker push phiroict/noted2xero_web:$(N2X_VERSION)_arm
build_container_arm:
	docker build -t phiroict/noted2xero_web:$(N2X_VERSION)_arm -f deploy/builder/Dockerfile_arm .
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
release_arm: test
	cargo doc
	cargo build --release
	cp target/release/noted2xero_cli noted2xero_command
	cp target/release/noted2xero_web noted2xero_web_service
	cp target/release/noted2xero_web deploy/container/noted2xero_web
	cd deploy/container && docker build -t phiroict/noted2xero_web:$(N2X_VERSION)_arm .
release-rc: version release
release-windows: test
	cargo doc
	cargo build --release --target x86_64-pc-windows-gnu
run_cli: build
	cp target/debug/noted2xero_cli noted2xero_cli/
	cd noted2xero_cli && ./noted2xero_cli 3045
run_web: build
	cp target/debug/noted2xero_web noted2xero_web/
	cd noted2xero_web && ./noted2xero_web
run_web_container:
	docker run -d -p 8000:8000 phiroict/noted2xero_web:$(N2X_VERSION)
run_web_container_arm:
	docker run -it -p 8000:8000 phiroict/noted2xero_web:$(N2X_VERSION)_arm
test:
	cargo test
deploy: release
	cd deploy/ansible && ansible-playbook --connection=local deploy-notedfolder.yml
run_stack:
	cd deploy/local-stack && docker-compose up -d
	firefox http://localhost:8180 &
run_stack_arm:
	cd deploy/local-stack-arm && docker-compose up -d
	firefox http://localhost:8180 &
stop_stack:
	cd deploy/local-stack && docker-compose down
run_stack_arm:
	cd deploy/local-stack-arm && docker-compose up -d
	firefox http://localhost:8180 &
stop_stack_arm:
	cd deploy/local-stack-arm && docker-compose down

.PHONY: deploy
build_frontend:
	docker build -f Dockerfile_nginx -t phiroict/xero_frontend:$(N2X_VERSION) .
	docker push phiroict/xero_frontend:$(N2X_VERSION)