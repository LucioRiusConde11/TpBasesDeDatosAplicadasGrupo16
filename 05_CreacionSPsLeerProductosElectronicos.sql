USE GRUPO_16
GO

CREATE OR ALTER PROCEDURE catalogo.ImportarDesdeExcelElectronicos
    @FilePath NVARCHAR(255) -- Ruta completa del archivo Excel
AS
BEGIN
    BEGIN TRY
        -- Configurar opciones avanzadas
        EXEC sp_configure 'show advanced options', 1;
        RECONFIGURE;
        EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
        RECONFIGURE;

        -- Crear tabla temporal para importar los datos
        IF OBJECT_ID('tempdb..#ProductosTemp') IS NOT NULL
            DROP TABLE #ProductosTemp;

        CREATE TABLE #ProductosTemp (
            Product VARCHAR(100) NULL,
            PrecioUnitarioenDolares VARCHAR(10) NULL
        );

        -- Construir la consulta OPENROWSET para importar desde Excel
        DECLARE @sql NVARCHAR(MAX) = 
        'INSERT INTO #ProductosTemp (Product, PrecioUnitarioenDolares)
         SELECT * FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
            ''SELECT * FROM [Sheet1$]''
        )';

        -- Ejecutar la consulta para cargar los datos
        EXEC sp_executesql @sql;

        -- Verificar la carga
        SELECT * FROM #ProductosTemp;

		-- Obtener valor del dolar
		IF OBJECT_ID('tempdb..#TempTableDolar') IS NOT NULL
            DROP TABLE #TempTableDolar;
		CREATE TABLE #TempTableDolar (ValorDolar DECIMAL(10,2));
		INSERT INTO #TempTableDolar EXEC [catalogo].[ObtenerValorDolar]
		UPDATE #ProductosTemp SET PrecioUnitarioenDolares =  PrecioUnitarioenDolares * (SELECT * FROM #TempTableDolar)

    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO