USE [GRUPO_16]
GO

CREATE OR ALTER PROCEDURE [catalogo].[importarVentasCsv]
    @FilePath NVARCHAR(255) 
AS
BEGIN
    BEGIN TRY
        -- Crear la tabla temporal para almacenar los datos del archivo CSV
        CREATE TABLE #tmp_ventas (
			ID_FACTURA VARCHAR(50),
			Tipo_De_Factura CHAR(1),
			Ciudad VARCHAR(50),
			Tipo_De_Cliente VARCHAR(30),
			Genero VARCHAR(50),
			Producto VARCHAR(200),
			Precio_Unitario DECIMAL(10,2),
			Cantidad int,
			Fecha VARCHAR(20),
			Hora VARCHAR(20),
			Medio_De_Pago VARCHAR(30),
			Legajo_Empleado VARCHAR(50),
			Identificador_Pago VARCHAR(100)
        );

        -- Construir la instrucción BULK INSERT con SQL dinámico
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
            BULK INSERT #tmp_ventas 
            FROM ''' + @FilePath + '''
            WITH (
				FORMAT = ''CSV'', 
                FIELDTERMINATOR = '';'',  -- Delimitador de campo
                ROWTERMINATOR = ''0x0a'',         -- Delimitador de fila
                FIRSTROW = 2,             -- Ignorar la primera fila de encabezado
                CODEPAGE = ''65001''              -- UTF-8
            );
        ';
		PRINT @sql

        -- Ejecutar la instrucción BULK INSERT usando SQL dinámico
        EXEC sp_executesql @sql;

        -- Seleccionar los datos de la tabla temporal para verificación
        --SELECT * FROM #tmp_ventas

		--tratamiento fecha
		UPDATE #tmp_ventas
		SET Fecha = Fecha + ' ' + Hora

		INSERT INTO ventas.Factura(id_factura_importado, FechaHora, Estado, ID_Empleado, ID_MedioPago)
		(
		SELECT tmp.ID_FACTURA,
			   CASE
					WHEN ISDATE(tmp.Fecha) = 1 THEN CONVERT(DATETIME, tmp.Fecha, 103)
					ELSE CONVERT(DATETIME, tmp.Fecha, 101)
			   END,
			   'Aprobada',
			   (SELECT e.ID FROM tienda.Empleado e WHERE e.Legajo = tmp.Legajo_Empleado COLLATE Modern_Spanish_CI_AS),
			   (SELECT m.ID FROM ventas.MedioPago m WHERE tmp.Medio_De_Pago = m.Descripcion_ENG  COLLATE Modern_Spanish_CI_AS OR tmp.Medio_De_Pago = m.Descripcion_ESP COLLATE Modern_Spanish_CI_AS)
			FROM #tmp_ventas tmp
			WHERE NOT EXISTS 
			(
				SELECT 1
					FROM ventas.Factura f
					WHERE 
					--(f.ID_Empleado = (SELECT e.ID FROM tienda.Empleado e WHERE e.Legajo = tmp.Legajo_Empleado COLLATE Modern_Spanish_CI_AS)
					--AND CONVERT(DATETIME,(CAST(PARSE(tmp.Fecha AS DATETIME USING 'es-ES') AS DATETIME)) + ' ' + tmp.Hora, 103) = f.FechaHora)
					--OR
					(f.id_factura_importado = tmp.ID_FACTURA COLLATE Modern_Spanish_CI_AS)
			)
		)

		INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario, TipoCliente, GeneroCliente, IdentificadorPago)
		(
			SELECT (SELECT f.ID FROM ventas.Factura f WHERE f.id_factura_importado = tmp.ID_FACTURA COLLATE Modern_Spanish_CI_AS),
				   (SELECT p.ID FROM catalogo.Producto p WHERE p.Nombre = tmp.Producto COLLATE Modern_Spanish_CI_AS AND p.PrecioUnitario = tmp.Precio_Unitario),
				   tmp.Cantidad,
				   tmp.Precio_Unitario,
				   tmp.Tipo_De_Cliente,
				   tmp.Genero,
				   tmp.Identificador_Pago
				FROM #tmp_ventas tmp
				WHERE NOT EXISTS
				(
					SELECT 1
						FROM ventas.DetalleFactura d
						WHERE d.ID_Factura = (SELECT f.ID FROM ventas.Factura f WHERE f.id_factura_importado = tmp.ID_FACTURA COLLATE Modern_Spanish_CI_AS)
				)
				
				AND EXISTS 
				(
					SELECT 1
						FROM ventas.Factura f 
						WHERE f.id_factura_importado = tmp.ID_FACTURA COLLATE Modern_Spanish_CI_AS
				) 
				AND EXISTS 
				(
					SELECT 1
						FROM catalogo.Producto p
						WHERE p.Nombre = tmp.Producto COLLATE Modern_Spanish_CI_AS AND p.PrecioUnitario = tmp.Precio_Unitario
				)
				
		)

    END TRY
    BEGIN CATCH
        -- Capturar errores
        PRINT 'Error al importar los datos: ' + ERROR_MESSAGE();
    END CATCH;

    -- Eliminar la tabla temporal al final del procedimiento
    DROP TABLE IF EXISTS #tmp_ventas;
END;