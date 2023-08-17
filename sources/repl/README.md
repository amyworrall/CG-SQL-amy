# CQL Playground

## CQL REPL
Experiment with CQL with [`go.sql`](go.sql)!

Run [`./go.sh`](go.sh) to compile `go.sql`. It will run the `go()` procedure in `go.sql`.

Use `./go.sh -vvv` to get verbose output.  This includes all the SQLite statements executed.

## Query Planner
You can get query plans for the SQL statements you write in `go.sql` by running [`./go_query_plan.sh`](go_query_plan.sh).
