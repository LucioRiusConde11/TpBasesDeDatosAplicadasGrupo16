Use master
go
IF NOT EXISTS ( SELECT name FROM master.dbo.sysdatabases WHERE name =
'GRUPO_16')
BEGIN
	CREATE DATABASE GRUPO_16
	COLLATE Latin1_General_CI_AI;
END
go
use GRUPO_16
go
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name =
'ventas')
BEGIN
	EXEC('CREATE SCHEMA ventas')
END
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name =
'catalogo')
BEGIN
	EXEC('CREATE SCHEMA catalogo')
END
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name =
'tienda')
BEGIN
	EXEC('CREATE SCHEMA tienda')
END
GO



