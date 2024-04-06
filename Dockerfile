# syntax = docker/dockerfile:1

# Use the official Ubuntu 22.04 LTS as a parent image
FROM ubuntu:22.04

# Set the working directory in the container
WORKDIR /usr/src/app

# Install dependencies
# This includes Node.js for Next.js and Go for the backend, and any other dependencies.
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    curl -OL https://golang.org/dl/go1.22.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz && \
    rm go1.22.0.linux-amd64.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Add Go to PATH
ENV PATH="/usr/local/go/bin:${PATH}"

# Install and configure opensshd
RUN apt-get update \
    && apt-get install -y openssh-server \
    && cp /etc/ssh/sshd_config /etc/ssh/sshd_config-original \
    && sed -i 's/^#\s*Port.*/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/^#\s*PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && mkdir -p /root/.ssh \
    && chmod 700 /root/.ssh \
    && mkdir /var/run/sshd \
    && chmod 755 /var/run/sshd \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy the entrypoint script into the container
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Set the entrypoint script to run on container start
ENTRYPOINT ["/docker-entrypoint.sh"]

# Keep the container running (this command can be overridden by the entrypoint script)
CMD ["tail", "-f", "/dev/null"]