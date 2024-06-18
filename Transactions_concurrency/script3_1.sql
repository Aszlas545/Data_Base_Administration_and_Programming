/*1. Przygotuj skrypt nr 1:
Rozpocznij transakcj�.
Wy�wietl wszystkich pracownik�w, kt�rzy zostali zatrudnieni w grudniu.
Wstrzymaj wykonanie skryptu na 15 sekund.
Wy�wietl wszystkich pracownik�w, kt�rzy zostali zatrudnieni w grudniu.
Zatwierd� transakcj�.*/

BEGIN TRANSACTION
	SELECT * FROM employees
	WHERE MONTH(hire_date) = 12

	WAITFOR DELAY '00:00:15';

	SELECT * FROM employees
	WHERE MONTH(hire_date) = 12
COMMIT TRANSACTION

SELECT * FROM employees
WHERE MONTH(hire_date) = 12