# If you're running this on a Silicon Mac, you'll get a warning that the image's platform
# doesn't match the detected host platform, but it's safe to ignore.
FROM mcr.microsoft.com/mssql/server:2022-latest

USER root
ENV ACCEPT_EULA=Y

# Install SQL Server Full Text Search
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  # We'll need curl and gpg to install packages from Microsoft's repo
  apt-get install -yq curl gpg && \
  # Get official Microsoft repository configuration
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
  curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server.list && \
  apt-get update && \
  # Install SQL Server Full Text Search
  apt-get install -y mssql-server-fts && \
  # Clean up the apt cache
  apt-get clean && \
  rm -rf /var/lib/apt/lists

# Symlink SQL Server tools to /usr/local/bin so we can use `sqlcmd` in the shell
# instead of using the full path to the executable
RUN ln -s /opt/mssql-tools*/bin/* /usr/local/bin/

# Create a directory for the setup scripts and data
RUN mkdir -p /setup/config
WORKDIR /setup/config

# Copy the Adventure Works database files
# (This is done in a separate layer for caching purposes)
COPY adventure-works ./adventure-works

# Copy the setup scripts and make them executable
COPY configure-db.sh entrypoint.sh .
RUN chmod +x *.sh

# Run the entrypoint script when the container starts.
# This will run the configuration script before starting SQL Server.
ENTRYPOINT ["./entrypoint.sh"]