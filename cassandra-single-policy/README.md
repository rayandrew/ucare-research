# Cassandra Single Load Balancer Policy

## Goal

Run only one node to process query plan

For research purpose only

## Running

Add env consist of

```
CASSANDRA_NODES="node1,node2,...,noden"
```

Run query in cqlsh

```sql
CREATE KEYSPACE test WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };

CREATE TABLE users (
  user_id uuid,
  first_name text,
  last_name text,
  email text,
  created_date timestamp,
  PRIMARY KEY (user_id)
);
```

And then run

```bash
gradle run
```

### Author

Ray Andrew <raydreww@gmail.com>
