-- Crear el procedimiento almacenado
CREATE OR ALTER PROCEDURE catalogo.ImportarDesdeExcel
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
            IdProducto  VARCHAR(20) NULL,
            NombreProducto VARCHAR(100) NULL,
            Proveedor VARCHAR(100) NULL,
			Categoría VARCHAR(100) NULL,
			CantidadPorUnidad VARCHAR(100) NULL,
			PrecioUnidad VARCHAR(100) NULL,
        );

        -- Construir la consulta OPENROWSET para importar desde Excel
        DECLARE @sql NVARCHAR(MAX) = 
        'INSERT INTO #ProductosTemp (IdProducto, NombreProducto, Proveedor, Categoría, CantidadPorUnidad, PrecioUnidad)
         SELECT * FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
            ''SELECT * FROM [Listado de Productos$]''
        )';

        -- Ejecutar la consulta para cargar los datos
        EXEC sp_executesql @sql;

        -- Verificar la carga
        SELECT * FROM #ProductosTemp;


    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

