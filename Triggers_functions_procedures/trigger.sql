CREATE OR ALTER TRIGGER on_job_title_change
ON employees
AFTER UPDATE
AS
IF (UPDATE(job_id))
BEGIN
	SET NOCOUNT ON;

	DECLARE
	@emp_id INT,
	@h_date DATE,
	@j_id_old VARCHAR(30),
	@j_id_new VARCHAR(30),
	@d_id INT,
	@sal FLOAT,
	@f_name VARCHAR(30),
	@l_name VARCHAR(30),
	@sal_min FLOAT,
	@sal_max FLOAT;

	SELECT @j_id_new = job_id FROM inserted;
	SELECT @sal_min = min_salary, @sal_max = max_salary FROM jobs WHERE job_id = @j_id_new;

	DECLARE c CURSOR FOR
	SELECT employee_id, hire_date, job_id, department_id, salary, first_name, last_name FROM deleted;

	OPEN c;
    
    FETCH NEXT FROM c INTO @emp_id, @h_date, @j_id_old, @d_id, @sal, @f_name, @l_name;
	WHILE @@FETCH_STATUS = 0
    BEGIN
		UPDATE employees
		SET hire_date = DATEADD(DAY, 1, GETDATE())
		WHERE employee_id = @emp_id;
	
		INSERT INTO job_history VALUES(@emp_id, @h_date, GETDATE(), @j_id_old, @d_id);

		IF (@sal < @sal_min)
			BEGIN
			UPDATE employees
			SET salary = @sal_min
			WHERE employee_id = @emp_id;
			PRINT(CONCAT('P³aca pracownika ', @f_name, ' ', @l_name, ' podnios³a siê o: ', @sal_min - @sal));
			END;
		ELSE IF (@sal > @sal_max)
			BEGIN
			UPDATE jobs
			SET max_salary = @sal
			WHERE job_id = @j_id_new;
			END;
		FETCH NEXT FROM c INTO @emp_id, @h_date, @j_id_old, @d_id, @sal, @f_name, @l_name;
    END;
	CLOSE c;
    DEALLOCATE c;
END;