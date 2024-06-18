/*1. Przygotuj skrypt nr 1:
Rozpocznij transakcjê.
Wyœwietl wszystkich pracowników, którzy zostali zatrudnieni w grudniu.
Wstrzymaj wykonanie skryptu na 15 sekund.
Wyœwietl wszystkich pracowników, którzy zostali zatrudnieni w grudniu.
ZatwierdŸ transakcjê.*/

BEGIN TRANSACTION
	SELECT * FROM employees
	WHERE MONTH(hire_date) = 12

	WAITFOR DELAY '00:00:15';

	SELECT * FROM employees
	WHERE MONTH(hire_date) = 12
COMMIT TRANSACTION

SELECT * FROM employees
WHERE MONTH(hire_date) = 12