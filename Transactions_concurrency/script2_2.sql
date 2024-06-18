BEGIN TRANSACTION
	SELECT request_session_id, resource_type, request_type, request_mode, request_owner_type  
	FROM sys.dm_tran_locks WHERE request_session_id = 58;

    SELECT * FROM employees WITH (TABLOCK, HOLDLOCK)

    SELECT request_session_id, resource_type, request_type, request_mode, request_owner_type  
	FROM sys.dm_tran_locks WHERE request_session_id = 58;
