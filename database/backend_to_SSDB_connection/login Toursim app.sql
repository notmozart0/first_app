CREATE LOGIN admin123
WITH PASSWORD = 'admin@project';
GO

USE ToursimDatabase;
GO

CREATE USER admin123
FOR LOGIN admin123;
GO

ALTER ROLE db_owner
ADD MEMBER admin123;
GO
