USE [GRUPO_16]
GO
/****** Object:  StoredProcedure [catalogo].[importarCatalogoCsv]    Script Date: 27/10/2024 23:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [catalogo].[importarCatalogoCsv]
    @FilePath NVARCHAR(255) 
AS
BEGIN
    BEGIN TRY
        -- Crear la tabla temporal para almacenar los datos del archivo CSV
        CREATE TABLE #staging_catalogo_producto (
            ID INT IDENTITY PRIMARY KEY,
            Nombre VARCHAR(100) NOT NULL,
            PrecioUnitario DECIMAL(10, 2) NOT NULL,
            PrecioReferencia DECIMAL(10,2),
            UnidadReferencia VARCHAR(10),
            Fecha DATETIME NOT NULL,
            Categoria VARCHAR(100)
        );

        -- Construir la instrucción BULK INSERT con SQL dinámico
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
            BULK INSERT #staging_catalogo_producto
            FROM ''' + @FilePath + '''
            WITH (
				FORMAT = ''CSV'', 
                FIELDTERMINATOR = '','',  -- Delimitador de campo
                ROWTERMINATOR = ''0x0a'',         -- Delimitador de fila
                FIRSTROW = 2,             -- Ignorar la primera fila de encabezado
                CODEPAGE = ''65001''              -- UTF-8
            );
        ';
		PRINT @sql
        -- Ejecutar la instrucción BULK INSERT usando SQL dinámico
        EXEC sp_executesql @sql;
        -- Normalizacion de campos
        
        -- Seleccionar los datos de la tabla temporal para verificación
        INSERT INTO catalogo.Producto (Nombre, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha, ID_Categoria)
        SELECT Nombre, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha,
		(SELECT ID FROM catalogo.CategoriaProducto cp WHERE tmpProd.Categoria = cp.Categoria) FROM #staging_catalogo_producto tmpProd
        

        -- catalogo.InsertarProducto STORE PROCEDURE INSERCION 

    END TRY
    BEGIN CATCH
        -- Capturar errores
        PRINT 'Error al importar los datos: ' + ERROR_MESSAGE();
    END CATCH;

    -- Eliminar la tabla temporal al final del procedimiento
    DROP TABLE IF EXISTS #staging_catalogo_producto;
END;

