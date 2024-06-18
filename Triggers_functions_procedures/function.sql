CREATE OR ALTER FUNCTION employee_num (@job_title_arg VARCHAR(30), 
									   @department_name_arg VARCHAR(30), 
									   @country_name_arg VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @employee_amt INT;
	SELECT @employee_amt = COUNT(*) FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
	JOIN departments d ON d.department_id = e.department_id
	JOIN locations l ON l.location_id = d.location_id
	JOIN countries c ON c.country_id = l.country_id
	WHERE j.job_title = @job_title_arg
	AND d.department_name = @department_name_arg
	AND c.country_name = @country_name_arg
	
	RETURN(@employee_amt)
END;
