/*Przygotuj skrypt nr 1:
Rozpocznij transakcj�.
Wy�wietl pensj� pracownika o identyfikatorze r�wnym 100.
Wstrzymaj wykonanie skryptu na 15 sekund.
Wy�wietl pensj� pracownika o identyfikatorze r�wnym 100.
Zatwierd� transakcj�.*/

BEGIN TRANSACTION 
	SELECT salary FROM employees WHERE employee_id = 100;
	WAITFOR DELAY '00:00:15';
	SELECT salary FROM employees WHERE employee_id = 100;
COMMIT TRANSACTION

SELECT salary FROM employees WHERE employee_id = 100;