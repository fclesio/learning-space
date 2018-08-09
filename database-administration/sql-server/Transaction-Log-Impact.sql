SELECT transaction_id, DB_NAME(database_id) DatabaseName,
database_transaction_begin_time TransactionBegin,
CASE database_transaction_type
WHEN 1 THEN 'Read/Write'
WHEN 2 THEN 'Read only'
WHEN 3 THEN 'System' END AS TransactionType,
CASE database_transaction_state
WHEN 1 THEN 'Not Initialized'
WHEN 3 THEN 'Transaction No Log'
WHEN 4 THEN 'Transaction with Log'
WHEN 5 THEN 'Transaction Prepared'
WHEN 10 THEN 'Commited'
WHEN 11 THEN 'Rolled Back'
WHEN 12 THEN 'Commited and Log Generated' END AS TransactionState,
database_transaction_log_record_count LogRecordCount,
database_transaction_log_bytes_used LogBytesUsed,
database_transaction_log_bytes_reserved LogBytesReserved
FROM sys.dm_tran_database_transactions
WHERE transaction_id > 1000
