FROM archlinux:base-devel-20220522.0.57327 as builder
RUN pacman -Syu --noconfirm && pacman -S rustup gcc --noconfirm && rustup install nightly && rustup override set nightly && mkdir -p /src
WORKDIR /src
COPY . .
RUN cargo test && cargo build --release
FROM archlinux:base-devel-20220522.0.57327
RUN mkdir /app
WORKDIR /app
COPY --from=builder /src/target/release/noted2xero_web noted2xero_web
COPY --from=builder /src/Rocket.toml Rocket.toml
CMD ["./noted2xero_web"]

