#!/bin/bash
pg_path=/opt/PostgreSQL/9.0
psql=$pg_path/bin/psql
#
$psql -U postgres -f create_role.sql
#
$psql -U postgres -f create_db.sql
#
$psql -U postgres -d rt_news -f $pg_path/share/postgresql/contrib/pgcrypto.sql
#
$psql -U postgres -d rt_news -f create_tables.sql

