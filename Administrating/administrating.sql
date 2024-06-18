--Zadanie 1

--1. Utwórz nowe loginy o nazwach login1, login2 i login3 z domyœln¹ baz¹ danych HR.
CREATE LOGIN login1 WITH PASSWORD = 'pas1', DEFAULT_DATABASE = HR;
CREATE LOGIN login2 WITH PASSWORD = 'pas2', DEFAULT_DATABASE = HR;
CREATE LOGIN login3 WITH PASSWORD = 'pas3', DEFAULT_DATABASE = HR;

--2. Utwórz nowych u¿ytkowników w bazie danych HR o nazwach user1, user2 i user3 przypisanych do loginów login1, login2 i login3.
USE HR;
GO

CREATE USER user1 FOR LOGIN login1;
CREATE USER user2 FOR LOGIN login2;
CREATE USER user3 FOR LOGIN login3;

--3. Nadaj u¿ytkownikom user1, user2 i user3 uprawnienia do wyœwietlania departamentów.
GRANT SELECT ON departments TO user1, user2, user3;

--4. Utwórz now¹ rolê o nazwie role1 i uczyñ u¿ytkownika user1 jej w³aœcicielem.
CREATE ROLE role1;
ALTER AUTHORIZATION ON ROLE::role1 TO user1;

--5. Nadaj u¿ytkownikowi user1 uprawnienia do dodawania departamentów z mo¿liwoœci¹ dalszego przekazywania uprawnieñ.
GRANT INSERT ON departments TO user1 WITH GRANT OPTION;

--6. Nadaj roli role1 uprawnienia do usuwania departamentów.
GRANT DELETE ON departments to role1;

--7. Jako user1 nadaj u¿ytkownikowi user2 uprawnienia do dodawania departamentów.
EXECUTE AS USER = 'user1';
GRANT INSERT ON departments to user2;
REVERT;

--8. Jako user1 nadaj u¿ytkownikowi user2 rolê role1.
EXECUTE AS USER = 'user1';
ALTER ROLE role1 ADD MEMBER user2;
REVERT;

--9. Pozbaw u¿ytkownika user1 uprawnieñ do dodawania departamentów.
REVOKE INSERT ON departments FROM user1 CASCADE;

--10. Pozbaw u¿ytkownika user1 roli role1.
ALTER ROLE role1 DROP MEMBER user1;

--11. Czy jako u¿ytkownik user2 mo¿esz nadaæ u¿ytkownikowi user3 uprawnienia do dodawania departamentów?
EXECUTE AS USER = 'user2';
GRANT INSERT ON departments TO user3;
REVERT;

--12. Czy jako u¿ytkownik user2 mo¿esz nadaæ u¿ytkownikowi user3 rolê role1?
EXECUTE AS USER = 'user2';
ALTER ROLE role1 ADD MEMBER user3;
REVERT;

--13. Czy jako u¿ytkownik user1 mo¿esz nadaæ u¿ytkownikowi user3 rolê role1?
EXECUTE AS USER = 'user1';
ALTER ROLE role1 ADD MEMBER user3;
REVERT;
--Zadanie 2

--1. Utwórz tabelê o nazwie admin_logs, która zawieraæ bêdzie nastêpuj¹ce pola:
--log_id typu numerycznego bêd¹ce kluczem g³ównym,
--log_desc typu znakowego,
--log_data typu datowego (z uwzglêdnieniem czasu).
CREATE TABLE admin_logs (
	log_id INT PRIMARY KEY IDENTITY(1,1),
	log_desc VARCHAR(30),
	log_data DATETIME
);

--2. Utwórz nowe zadanie o nazwie login_report, które:
--przy ka¿dym uruchomieniu doda do tabeli admin_logs wpis zawieraj¹cy liczbê wszystkich loginów,
--pocz¹wszy od 1 grudnia 2023 roku bêdzie wykonywane codziennie o godzinie 2:00.
USE msdb;
GO

EXECUTE sp_add_schedule @schedule_name = 'login_report_schedule',
						@freq_type = 4,
						@freq_interval = 1,
						@active_start_time = 020000,
						@active_start_date = 20231201;

EXECUTE sp_add_job @job_name = 'login_report';

EXECUTE sp_add_jobstep @step_name = 'login_report_step',
					   @job_name = 'login_report',
					   @database_name = 'HR',
					   @command = 'INSERT INTO admin_logs 
								   VALUES(CONCAT(''total logs: '',(SELECT COUNT(*) FROM sys.server_principals)), GETDATE());';

EXECUTE sp_attach_schedule @job_name = 'login_report',
						   @schedule_name = 'login_report_schedule';

EXEC sp_add_jobserver @job_name = 'login_report', @server_name = '(local)';

SELECT *
FROM sys.server_principals
WHERE name = 'login1' OR name = 'login2' OR name = 'login3'

SELECT *
FROM sys.database_principals
WHERE name = 'user1' OR name = 'user2' OR name = 'user3'

SELECT 
    [perm].[permission_name],
    [perm].[state_desc],
    [sch].[name] AS [schema_name],
    [obj].[name] AS [object_name],
    [usr].[name] AS [user_name]
FROM 
    sys.database_permissions AS [perm]
JOIN 
    sys.database_principals AS [usr] ON [perm].[grantee_principal_id] = [usr].[principal_id]
LEFT JOIN 
    sys.objects AS [obj] ON [perm].[major_id] = [obj].[object_id]
LEFT JOIN 
    sys.schemas AS [sch] ON [obj].[schema_id] = [sch].[schema_id]
WHERE 
    [usr].[name] = 'user1'
	OR [usr].[name] = 'user2'
	OR [usr].[name] = 'user3'
	OR [usr].[name] = 'role1';

SELECT 
    r.[name] AS [RoleName],
    r.[type_desc] AS [RoleType],
    ISNULL(o.[name], 'No Owner') AS [OwnerName]
FROM sys.database_principals r
LEFT JOIN sys.database_principals o ON r.[owning_principal_id] = o.[principal_id]
WHERE r.[type] = 'R'
AND r.[name] = 'role1';

SELECT 
    rp.name AS 'Role Name',
    mp.name AS 'Member Name'
FROM 
    sys.database_role_members rm
JOIN 
    sys.database_principals rp ON rm.role_principal_id = rp.principal_id
JOIN 
    sys.database_principals mp ON rm.member_principal_id = mp.principal_id
WHERE 
    rp.name = 'role1';