FROM archlinux:base-devel-20220109.0.43549 as builder
RUN pacman -Syu --noconfirm && pacman -S rustup gcc --noconfirm && rustup install nightly && mkdir -p /src
WORKDIR /src
COPY . .
RUN cargo test && cargo build --release
FROM archlinux:base-devel-20220109.0.43549
RUN mkdir /app
WORKDIR /app
COPY --from=builder /src/target/release/noted2xero_web noted2xero_web
CMD ["./noted2xero_web"]

