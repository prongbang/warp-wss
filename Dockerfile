# Tells docker to use the latest Rust official image
FROM rust:latest

ENV HEROKU_PORT=$PORT
ENV PORT=$HEROKU_PORT

# Copy our current working directory into the container
COPY ./ ./

# Create the release build
RUN cargo build --release

# Generate our self signed certs (change these parameters accordingly!)
# RUN openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.rsa -out cert.pem \
#     -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"

# Expose the port our app is running on
EXPOSE $HEROKU_PORT

# Run the application!
CMD ["./target/release/warp-wss"]