/*2. Przygotuj skrypt nr 2:
Rozpocznij transakcj�.
Dodaj nowego pracownika, kt�ry zosta� zatrudniony 1 grudnia 2022 roku.
Zatwierd� transakcj�*/

BEGIN TRANSACTION
	INSERT INTO employees VALUES ( 250 , 'Mr�wka' , 'Pustynna' , 'MPUSTYNNA' , '515.127.4564' , CONVERT(DATE, '1-12-2022', 105) , 'PU_CLERK' , 2800 , NULL , 114 , 30 );
COMMIT TRANSACTION