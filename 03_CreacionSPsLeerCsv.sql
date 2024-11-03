USE [GRUPO_16]
GO
/****** Object:  StoredProcedure [catalogo].[importarCatalogoCsv]    Script Date: 27/10/2024 23:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [catalogo].[importarCatalogoCsv]
    @FilePath NVARCHAR(255) 
AS
BEGIN
    BEGIN TRY
        -- Crear la tabla temporal para almacenar los datos del archivo CSV
        CREATE TABLE #staging_catalogo_producto (
            id INT,
            category VARCHAR(100),
            name VARCHAR(100),
            price DECIMAL(10, 2),
            reference_price DECIMAL(10, 2),
            reference_unit VARCHAR(20),
            date DATETIME
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
                FIRSTROW = 1,             -- Ignorar la primera fila de encabezado
                CODEPAGE = ''65001''              -- UTF-8
            );
        ';
		PRINT @sql

        -- Ejecutar la instrucción BULK INSERT usando SQL dinámico
        EXEC sp_executesql @sql;

        -- Seleccionar los datos de la tabla temporal para verificación
        --SELECT * FROM #staging_catalogo_producto;

		WITH cte_Duplicados
		AS
		(
		SELECT tmp.id, ROW_NUMBER() OVER (PARTITION BY tmp.name, tmp.reference_price, tmp.reference_unit, tmp.price ORDER BY tmp.date) as Aparicion
			FROM #staging_catalogo_producto tmp
		)

		/*
		SELECT *
			FROM cte_Duplicados
			WHERE Aparicion > 1
		*/
		DELETE FROM cte_Duplicados
		WHERE Aparicion > 1
		
		INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
		(
			SELECT tmp.name,
				   (SELECT c.ID FROM catalogo.CategoriaProducto c WHERE c.Categoria = tmp.category COLLATE Modern_Spanish_CI_AS),
				   tmp.price,
				   tmp.reference_price,
				   tmp.reference_unit,
				   tmp.date
				FROM #staging_catalogo_producto tmp
				WHERE NOT EXISTS
				(
					SELECT 1
						FROM catalogo.Producto p 
						WHERE p.Nombre = tmp.name COLLATE Modern_Spanish_CI_AS
						AND p.PrecioUnitario = tmp.price
						AND p.PrecioReferencia = tmp.reference_price 
						AND p.UnidadReferencia = tmp.reference_unit COLLATE Modern_Spanish_CI_AS
				)
		)
		

    END TRY
    BEGIN CATCH
        -- Capturar errores
        PRINT 'Error al importar los datos: ' + ERROR_MESSAGE();
    END CATCH;

    -- Eliminar la tabla temporal al final del procedimiento
    DROP TABLE IF EXISTS #staging_catalogo_producto;
END;