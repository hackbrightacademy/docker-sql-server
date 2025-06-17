#!/bin/bash

# Wait 60 seconds for SQL Server to start up by ensuring that
# calling SQLCMD does not return an error code, which will ensure that sqlcmd is accessible
# and that system and user databases return "0" which means all databases are in an "online" state
# https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2017

DBSTATUS=1
ERRCODE=1
i=0

while [[ $DBSTATUS -ne 0 ]] && [[ $i -lt 120 ]] && [[ $ERRCODE -ne 0 ]]; do
  i=$i+1
  DBSTATUS=$(/opt/mssql-tools18/bin/sqlcmd -h -1 -t 1 -U sa -P $SA_PASSWORD -C -Q "SET NOCOUNT ON; Select SUM(state) from sys.databases")
  ERRCODE=$?
  sleep 1
done

if [[ $DBSTATUS -ne 0 ]] || [[ $ERRCODE -ne 0 ]]; then
  echo "SQL Server took more than 120 seconds to start up or one or more databases are not in an ONLINE state"
  exit 1
fi

# Create dev user and add to sysadmin role
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -C -Q "CREATE LOGIN $DEV_USER WITH PASSWORD = '$SA_PASSWORD'; ALTER SERVER ROLE sysadmin ADD MEMBER $DEV_USER"

# Run the setup script to create the DB and the schema in the DB
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -C -i /setup/config/adventure-works/instawdb.sql -o /src/output

echo "*** SQL Server is ready! ***"
