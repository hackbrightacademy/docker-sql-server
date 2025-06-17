# 🐳 SQL Server Linux with Docker

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [sqlcmd](https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility?view=sql-server-ver17&tabs=go%2Cwindows%2Cwindows-support&pivots=cs1-bash#download-and-install-sqlcmd)

> [!TIP]
> You can install both prerequisites on macOS using Homebrew:
>
> ```bash
> brew install --cask docker
> brew install sqlcmd
> ```

## Quickstart

This will build the image and start a container named `mssql` in the background.

```
docker compose -p mssql up -d --build
```

The container will start and perform some initial configuration on the database server. Give it a few seconds to finish up.
Once it's done, you can connect to the database from your local machine using `sqlcmd`.

```
sqlcmd -U dev -P Test1234 -C
```

> [!TIP]
> Not sure if the database server is ready? You can check the container's logs to monitor
> its progress either in Docker Desktop or by running `docker logs mssql -f`.








