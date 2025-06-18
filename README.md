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

## Container features

### Data persistence

Data used by the database server is stored in a Docker-managed volume called
`mssql-volume`. This means you can safely stop (and even remove!) the container without
losing your data.

### Sharing files between your machine and the container

You can share files between your machine and the container by adding them to the `src/`
folder in this repository. You likely won't need to do this too often, because you can
connect to the database server using `sqlcmd` from your machine, but we provide this just
in case.

### The `dev` user

By default, SQL Server comes with a user named `sa` that with full permissions. It's a bad
practice to use this user, so the container will create a new user named `dev` for you.
You'll still have all the permissions you need to do whatever you want with the database.

### AdventureWorks sample database

The container will automatically create the **AdventureWorks** sample database for you,
including all the tables and data using the files in `adventure-works/`.

These files are a copy of [the original
files](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/adventure-works)
from (microsoft/sql-server-samples)[https://github.com/microsoft/sql-server-samples], with
some modifications to make them work with SQL Server for Linux.

### Full Text Search

Full Text Search is enabled in the container. You probably won't need to use it, but the
**AdventureWorks** sample database makes use of it so why not? 🤷

## Configuration

### Customizing the username and password

You can customize the username and password for the `dev` user by setting the `DEV_USER`
and `SA_PASSWORD` environment variables in the `docker-compose.yml` file.

```yaml
services:
  mssql:
    # ...
    environment:
      - SA_PASSWORD=your-custom-password
      - DEV_USER=your-custom-username
```

> [!CAUTION]
> Your password *must* adhere to SQL Server's password policy or the container will fail to
> start. It should include at least 8 characters of at least three of these four categories:
> uppercase letters, lowercase letters, numbers and non-alphanumeric symbols.

### Customizing the shared folder

If you want to use a different folder to share files between your machine and the container,
you can change the `src/` folder in the `docker-compose.yml` file.

```yaml
services:
  mssql:
    # ...
    volumes:
      - /path/to/a/folder/on/your/machine:/src
```