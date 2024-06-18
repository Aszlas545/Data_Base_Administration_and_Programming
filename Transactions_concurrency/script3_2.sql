/*2. Przygotuj skrypt nr 2:
Rozpocznij transakcjê.
Dodaj nowego pracownika, który zosta³ zatrudniony 1 grudnia 2022 roku.
ZatwierdŸ transakcjê*/

BEGIN TRANSACTION
	INSERT INTO employees VALUES ( 250 , 'Mrówka' , 'Pustynna' , 'MPUSTYNNA' , '515.127.4564' , CONVERT(DATE, '1-12-2022', 105) , 'PU_CLERK' , 2800 , NULL , 114 , 30 );
COMMIT TRANSACTION