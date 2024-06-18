SELECT session_id, login_name, status, host_name, program_name
FROM sys.dm_exec_sessions
WHERE is_user_process = 1 AND status = 'running';

BEGIN TRANSACTION 
	SELECT * FROM employees;

	UPDATE employees
	SET salary = salary + 1000
ROLLBACK TRANSACTION