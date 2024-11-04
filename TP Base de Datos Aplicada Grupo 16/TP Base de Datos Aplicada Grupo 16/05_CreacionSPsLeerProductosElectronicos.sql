USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE catalogo.ImportarDesdeExcelElectronicos
    @FilePath NVARCHAR(255) -- Ruta completa del archivo Excel
AS
BEGIN
	DECLARE @valorDolar as INT;
	SET @valorDolar = catalogo.ConversionDolarPeso()
	IF (@valorDolar = 0)
	BEGIN
		PRINT 'Error al obtener el valor del dolar en pesos'
		RETURN
	END

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
		IF NOT EXISTS (SELECT 1 FROM catalogo.CategoriaProducto WHERE Categoria = 'Electronico' AND LineaProducto = 'Accesorio')
		BEGIN
			INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
			VALUES ('Accesorio', 'Electronico')
		END
		
		INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
		(
			SELECT tmp.Product,
				   (SELECT c.ID FROM catalogo.CategoriaProducto c WHERE c.Categoria = 'Electronico'),
				   CAST(tmp.PrecioUnitarioenDolares as DECIMAL(10,2)) * @valorDolar,
				   CAST(tmp.PrecioUnitarioenDolares as DECIMAL(10,2)),
				   'USD',
				   GETDATE()
				FROM #ProductosTemp tmp
				WHERE NOT EXISTS 
					(
						SELECT 1
							FROM catalogo.Producto p
							WHERE p.Nombre = tmp.Product COLLATE Modern_Spanish_CI_AS AND p.PrecioReferencia = CAST(tmp.PrecioUnitarioenDolares as DECIMAL(10,2))
					)
		)

    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO