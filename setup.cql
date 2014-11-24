
CREATE KEYSPACE IF NOT EXISTS simple
WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': '1'};
