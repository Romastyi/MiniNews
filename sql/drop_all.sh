#!/bin/bash
psql=/opt/PostgreSQL/9.0/bin/psql
#
$psql -U postgres -d rt_news -f drop_tables.sql
#
$psql -U postgres -c "drop database rt_news;"
#
$psql -U postgres -c "drop role rt_news;"
