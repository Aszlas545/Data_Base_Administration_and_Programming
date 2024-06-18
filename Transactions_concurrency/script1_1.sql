BEGIN TRANSACTION
	DECLARE @salary INT
	SELECT @salary = salary FROM employees WHERE employee_id = 100;

	WAITFOR DELAY '00:00:15';

	SET @salary = @salary - 1000;

	UPDATE employees
	SET salary = @salary
	WHERE employee_id = 100;

	SELECT @salary

COMMIT TRANSACTION;

SELECT salary FROM employees WHERE employee_id = 100;