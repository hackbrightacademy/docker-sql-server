FROM mcr.microsoft.com/mssql/server:2022-latest

USER root
ENV ACCEPT_EULA=Y

# Install SQL Server Full Text Search
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -yq curl gpg && \
  # Get official Microsoft repository configuration
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
  curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server.list && \
  apt-get update && \
  # Install package
  apt-get install -y mssql-server-fts && \
  # Cleanup
  apt-get clean && \
  rm -rf /var/lib/apt/lists

# Symlink SQL Server tools to /usr/local/bin so we can use `sqlcmd` in the shell
# instead of using the full path to the executable
RUN ln -s /opt/mssql-tools*/bin/* /usr/local/bin/

# Copy setup scripts and data
RUN mkdir -p /setup/config
WORKDIR /setup/config

COPY adventure-works ./adventure-works

COPY configure-db.sh entrypoint.sh .
RUN chmod +x *.sh
ENTRYPOINT ["./entrypoint.sh"]