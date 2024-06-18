BEGIN TRANSACTION
	DECLARE @salary INT
	SELECT @salary = salary FROM employees WHERE employee_id = 100;

	SET @salary = @salary - 2000;

	UPDATE employees
	SET salary = @salary
	WHERE employee_id = 100;

	SELECT @salary

COMMIT TRANSACTION;

