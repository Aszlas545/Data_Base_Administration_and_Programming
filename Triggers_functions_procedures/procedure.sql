CREATE OR ALTER PROCEDURE change_title_in_country @job_title_old VARCHAR(30), @job_title_new VARCHAR(30), @country_name VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
	@records_changed INT = 0,
	@dep_id INT,
	@dep_name VARCHAR(30),
	@job_id_old VARCHAR(30),
	@job_id_new VARCHAR(30);

	IF (SELECT COUNT(*) 
		FROM countries 
		WHERE country_name = @country_name) = 0 
		BEGIN
			DECLARE @msg1 VARCHAR(200) = 'Brak kraju ' + @country_name;
			THROW 50001, @msg1, 1
		END;
	IF (SELECT COUNT(*) 
		FROM departments d 
		JOIN locations l ON l.location_id = d.location_id 
		JOIN countries c ON c.country_id=l.country_id 
		WHERE country_name = @country_name) = 0 
		BEGIN
			DECLARE @msg2 VARCHAR(200) = 'Brak departamentów w kraju ' + @country_name;
			THROW 50002, @msg2, 1
		END;
	IF (SELECT COUNT(*) 
		FROM employees e
		JOIN departments d ON d.department_id = e.department_id 
		JOIN locations l ON l.location_id = d.location_id 
		JOIN countries c ON c.country_id = l.country_id 
		WHERE country_name = @country_name) = 0
		BEGIN
			DECLARE @msg3 VARCHAR(200) = 'Brak pracowników w kraju ' + @country_name;
			THROW 50003, @msg3, 1
		END;
	
	SELECT @job_id_new = job_id FROM jobs WHERE job_title = @job_title_new;
	SELECT @job_id_old = job_id FROM jobs WHERE job_title = @job_title_old;
	
	SELECT e.employee_id, e.first_name, e.last_name, d.department_name
	FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
	JOIN countries c ON l.country_id = c.country_id
	JOIN jobs j ON e.job_id = j.job_id
	WHERE c.country_name = @country_name
	AND j.job_title = @job_title_old;

	DECLARE cur CURSOR FOR
	SELECT d.department_id, d.department_name FROM departments d
	JOIN locations l ON l.location_id = d.location_id
	JOIN countries c ON l.country_id = c.country_id
	WHERE c.country_name = @country_name;
	
	OPEN cur;

    FETCH NEXT FROM cur INTO @dep_id, @dep_name;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(CONCAT('Dzia³: ', @dep_id, ' ', @dep_name));

		IF (SELECT COUNT(*) 
			FROM employees e
			JOIN departments d ON d.department_id = e.department_id
			JOIN jobs j ON j.job_id = e.job_id
			WHERE j.job_title = @job_title_old
			AND d.department_id = @dep_id) = 0
			BEGIN
				RAISERROR('Brak pracowników na stanowisku %s w departamencie %s w kraju %s', 10, 1, @job_title_old, @dep_name, @country_name);
				FETCH NEXT FROM cur INTO @dep_id, @dep_name;
				CONTINUE;
			END;

		SET @records_changed += dbo.employee_num(@job_title_old, @dep_name, @country_name);
		
		DECLARE @eid INT, @fn VARCHAR(30), @ln VARCHAR(30);

		DECLARE cur2 CURSOR FOR
		SELECT e.employee_id, e.first_name, e.last_name FROM employees e
		JOIN departments d ON d.department_id = e.department_id
		WHERE d.department_name = @dep_name
		AND e.job_id = @job_id_old;
		
		OPEN cur2;

		FETCH NEXT FROM cur2 INTO @eid, @fn, @ln;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT(CONCAT(@eid, ' ',  @fn, ' ', @ln))
			FETCH NEXT FROM cur2 INTO @eid, @fn, @ln;
		END;

		CLOSE cur2;
		DEALLOCATE cur2;

		UPDATE employees 
		SET job_id = @job_id_new
		FROM employees e
		JOIN departments d ON d.department_id = e.department_id
		WHERE d.department_id = @dep_id
		AND e.job_id = @job_id_old;
		
		FETCH NEXT FROM cur INTO @dep_id, @dep_name;
	END;
	CLOSE cur;
    DEALLOCATE cur;
	RETURN (@records_changed)
END;