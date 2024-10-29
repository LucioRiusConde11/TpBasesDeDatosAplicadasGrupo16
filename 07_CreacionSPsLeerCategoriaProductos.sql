USE GRUPO_16

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [catalogo].[ImportarCategoriaProducto]
	@FilePath NVARCHAR(255)
AS
BEGIN
		EXEC sp_configure 'show advanced options', 1;
        RECONFIGURE;	
        EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
        RECONFIGURE;
	

	BEGIN TRY 
		IF OBJECT_ID('tempdb..#tmp_CategoriaProducto') IS NOT NULL
            DROP TABLE #tmp_CategoriaProducto;

		CREATE TABLE #tmp_CategoriaProducto (
			Categoria VARCHAR(100) NOT NULL UNIQUE,
			LineaProducto VARCHAR(40)
		);

		DECLARE @sql NVARCHAR(MAX);
		SET @sql = N'
			INSERT INTO #tmp_CategoriaProducto (Categoria, LineaProducto)
			SELECT * FROM OPENROWSET(
				''Microsoft.ACE.OLEDB.12.0'',
				''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
				''SELECT * FROM [Clasificacion productos$]''
			)';

		EXEC sp_executesql @sql;

		SELECT * FROM #tmp_CategoriaProducto;

	END TRY
	BEGIN CATCH
		PRINT 'Error al importar los datos: ' + ERROR_MESSAGE();
	END CATCH;
	
	IF OBJECT_ID('tempdb..#tmp_CategoriaProducto') IS NOT NULL
        DROP TABLE #tmp_CategoriaProducto;

END;

--FUENTE: https://learn.microsoft.com/en-us/sql/relational-databases/import-export/import-data-from-excel-to-sql?view=sql-server-ver16 

EXEC catalogo.ImportarCategoriaProducto '..\..\TP_integrador_Archivos\Informacion_complementaria.xlsx'


