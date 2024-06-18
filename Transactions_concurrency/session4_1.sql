SELECT session_id FROM sys.dm_exec_sessions
WHERE is_user_process = 1 AND status = 'running';

BEGIN TRANSACTION
	SELECT request_session_id, resource_type, request_type, request_mode, request_owner_type  
	FROM sys.dm_tran_locks WHERE request_session_id = 65;

	SELECT * FROM employees WITH (TABLOCK, HOLDLOCK);

	SELECT request_session_id, resource_type, request_type, request_mode, request_owner_type  
	FROM sys.dm_tran_locks WHERE request_session_id = 65;
COMMIT TRANSACTION

SELECT request_session_id, resource_type, request_type, request_mode, request_owner_type  
	FROM sys.dm_tran_locks WHERE request_session_id = 65;
