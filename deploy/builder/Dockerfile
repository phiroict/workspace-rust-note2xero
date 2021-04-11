FROM archlinux as builder
RUN pacman -Syu --noconfirm && pacman -S rustup gcc --noconfirm
RUN rustup install nightly
ADD . .
RUN cargo test
RUN cargo build --release
FROM archlinux
RUN mkdir /app
WORKDIR /app
COPY --from=builder /target/release/noted2xero_web noted2xero_web
CMD ./noted2xero_web

