SELECT * FROM job_history
--zad1. part1.
CREATE TABLE visitors (
	visitor_id INT PRIMARY KEY IDENTITY(100, 10),
	employee_id NUMERIC(6, 0) FOREIGN KEY REFERENCES employees(employee_id) NOT NULL,
	company VARCHAR(30),
	people_number INT,
	parking BIT,
	enter_datetime DATETIME DEFAULT GETDATE(),
	exit_datetime DATETIME,
	CONSTRAINT vailid_exit_datetime
		CHECK(exit_datetime > enter_datetime),
		CHECK(exit_datetime <= GETDATE())
);
--zad1. part2.
INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
VALUES ((SELECT employee_id 
		 FROM employees 
		 WHERE first_name = 'Daniel' 
		 AND last_name = 'Faviet'), 
		 'RSM', 
		 1, 
		 1, 
		 '2023-10-12 9:00:00', 
		 DATEADD(hour,1,'2023-10-12 9:00:00'));

INSERT INTO visitors (employee_id, company, people_number, parking, enter_datetime, exit_datetime)
VALUES ((SELECT employee_id 
		 FROM employees 
		 WHERE first_name = 'Daniel' 
		 AND last_name = 'Faviet'), 
		 'KPMG', 
		 3, 
		 0, 
		 '2023-10-13 10:00:00', 
		 DATEADD(minute,90,'2023-10-13 10:00:00'));

--zad1. part3.
ALTER TABLE visitors
DROP COLUMN parking;

--zad1. part4.
UPDATE visitors
SET employee_id = (SELECT employee_id 
					FROM employees 
					WHERE first_name = 'John' 
					AND last_name = 'Chen')
WHERE company = 'KPMG';

--zad1. part5.
DELETE FROM visitors
WHERE employee_id = (SELECT employee_id 
					 FROM employees 
					 WHERE first_name = 'Daniel' 
					 AND last_name = 'Faviet');

--zad1. part6.
DROP TABLE visitors

--zad2. part1.
SELECT department_name FROM departments d
WHERE department_id NOT IN (SELECT department_id FROM employees WHERE department_id IS NOT NULL)

--zad2. part2.
SELECT e1.first_name, e1.last_name, e1.salary - AVG(e2.salary) AS salary_diffrence FROM employees e1
JOIN employees e2 ON e2.manager_id = e1.employee_id
WHERE e1.employee_id IN (SELECT manager_id FROM employees)
GROUP BY e1.employee_id, e1.first_name, e1.last_name, e1.salary

--zad2. part3.
SELECT city, CONCAT(postal_code, '_', country_id, UPPER(RIGHT(city, 3))) AS code FROM locations
WHERE LEN(postal_code)=5

--zad2. part4.
SELECT d.department_name FROM departments d
JOIN employees e ON d.department_id=e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) > (SELECT AVG(ct) FROM (SELECT ISNULL(COUNT(e.employee_id), '0') AS ct FROM departments d
				   LEFT JOIN employees e ON d.department_id=e.department_id
				   GROUP BY d.department_id, d.department_name) q)

--zad2. part5.
SELECT e.first_name, 
	   e.last_name, 
	   j.job_title,
	   (CASE WHEN jh.job_id IS NULL THEN 'actual' ELSE 'archive' END) AS actuality
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
LEFT JOIN job_history jh ON jh.employee_id = e.employee_id 
ORDER BY e.first_name, e.last_name, j.job_title

	SELECT e.first_name, e.last_name, j.job_title, 'archive' AS actuality FROM job_history jh
	JOIN jobs j on jh.job_id=j.job_id
	JOIN employees e ON e.employee_id=jh.employee_id
	UNION ALL
	SELECT e.first_name, e.last_name, j.job_title, 'actual' AS actuality FROM employees e
	JOIN jobs j on e.job_id = j.job_id
	ORDER BY last_name, first_name, job_title

--zad3.
SELECT * FROM employees;
SELECT * FROM jobs;
WITH menager AS (
   SELECT e.first_name, e.last_name, e.employee_id, e.manager_id
   FROM employees e
   WHERE e.first_name = 'Diana' AND e.last_name = 'Lorentz'
   UNION ALL
   SELECT e.first_name, e.last_name, e.employee_id, e.manager_id
   FROM employees e
   JOIN menager m ON e.employee_id = m.manager_id)
SELECT ROW_NUMBER() OVER (ORDER BY manager_id DESC)-1 AS employee_level, first_name, last_name
FROM menager;


WITH menager AS (
 SELECT 0 AS employee_level, e.first_name, e.last_name, e.employee_id, 
e.manager_id
 FROM employees e
 WHERE e.first_name = 'Diana' AND e.last_name = 'Lorentz'
 UNION ALL
 SELECT m.employee_level + 1, e.first_name, e.last_name, e.employee_id, 
e.manager_id
 FROM employees e
 JOIN menager m ON e.employee_id = m.manager_id)
SELECT employee_level, x.first_name, x.last_name
FROM menager x;

WITH menager AS (
   SELECT e.first_name, e.last_name, e.employee_id, e.manager_id
   FROM employees e
   WHERE e.first_name = 'Diana' AND e.last_name = 'Lorentz'
   UNION ALL
   SELECT e.first_name, e.last_name, e.employee_id, e.manager_id
   FROM employees e
   JOIN menager m ON e.employee_id = m.manager_id)
SELECT ROW_NUMBER() OVER (ORDER BY manager_id DESC)-1 AS employee_level, first_name, last_name
FROM menager;