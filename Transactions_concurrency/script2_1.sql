/*Przygotuj skrypt nr 1:
Rozpocznij transakcjê.
Wyœwietl pensjê pracownika o identyfikatorze równym 100.
Wstrzymaj wykonanie skryptu na 15 sekund.
Wyœwietl pensjê pracownika o identyfikatorze równym 100.
ZatwierdŸ transakcjê.*/

BEGIN TRANSACTION 
	SELECT salary FROM employees WHERE employee_id = 100;
	WAITFOR DELAY '00:00:15';
	SELECT salary FROM employees WHERE employee_id = 100;
COMMIT TRANSACTION

SELECT salary FROM employees WHERE employee_id = 100;