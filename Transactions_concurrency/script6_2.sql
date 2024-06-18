BEGIN TRANSACTION
	UPDATE employees
	SET salary = 30000
	WHERE employee_id = 100

	WAITFOR DELAY '00:00:15';

	UPDATE jobs
	SET max_salary = 30000
	WHERE job_title = 'President'
COMMIT TRANSACTION