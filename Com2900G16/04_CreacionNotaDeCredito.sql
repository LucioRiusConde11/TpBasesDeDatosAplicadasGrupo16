USE Com2900G16;
/*
--Alumnos
<Avella Mateo, 45318319
<Rius Conde Lucio, 41779534
<

GRUPO 16
ENTREGA: 05/11/24

Se requiere que importe toda la información antes mencionada a la base de datos:
	• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
	archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
	novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
	• Considere este comportamiento al generar el código. Debe admitir la importación de
	novedades periódicamente.
	• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
	realicen tareas por fuera de un SP.
	• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
	realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
	estructura requerida.
	• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
	cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
	en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
	interpretarlo como JSON o CSV). 

*/
-- Procedimiento para Generar Nota de Crédito
GO
CREATE PROCEDURE ventas.CrearNotaCredito
    @ID_Factura INT,              
    @ID_Cliente INT,              
    @ID_Producto INT = NULL,      
    @Cantidad INT = NULL,         
    @Motivo VARCHAR(255),         
    @Comprobante VARCHAR(10)              
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM ventas.Factura WHERE ID = @ID_Factura AND Estado IN ('Pagada', 'No pagada'))
            RAISERROR('La factura no existe o no es válida para una nota de crédito.', 16,1);

        IF NOT EXISTS (SELECT 1 FROM ventas.Factura F
                       INNER JOIN ventas.Venta V ON F.ID_Venta = V.ID
                       WHERE F.ID = @ID_Factura AND V.ID_Cliente = @ID_Cliente)
            RAISERROR('El cliente no coincide con la factura especificada.', 16,1);

        IF @ID_Producto IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 
                           FROM ventas.DetalleFactura DF
                           WHERE DF.ID_Factura = @ID_Factura AND DF.ID_Producto = @ID_Producto)
                RAISERROR('El producto especificado no pertenece a la factura.', 16,1);
        END;

        -- Calcular las cantidades y totales afectados
        DECLARE @CantidadAfectada INT;
        DECLARE @PrecioUnitario DECIMAL(18, 2);
        DECLARE @IVA DECIMAL(18, 2);
        DECLARE @SubtotalAfectado DECIMAL(18, 2);
        DECLARE @TotalAfectado DECIMAL(18, 2);

        IF @ID_Producto IS NOT NULL
        BEGIN
            -- Obtener detalles del producto en la factura
            SELECT TOP 1 
                @CantidadAfectada = CASE WHEN @Cantidad IS NOT NULL THEN @Cantidad ELSE DF.Cantidad END,
                @PrecioUnitario = DF.PrecioUnitario,
                @IVA = DF.IVA
            FROM ventas.DetalleFactura DF
            WHERE DF.ID_Factura = @ID_Factura AND DF.ID_Producto = @ID_Producto;

            -- Verificar que la cantidad no exceda la registrada en la factura
            IF @CantidadAfectada > (SELECT Cantidad FROM ventas.DetalleFactura
                                    WHERE ID_Factura = @ID_Factura AND ID_Producto = @ID_Producto)
                THROW 50004, 'La cantidad especificada excede la registrada en la factura.', 1;
        END
        ELSE
        BEGIN
            -- Si no se especifica producto, afecta toda la factura
            SELECT 
                @SubtotalAfectado = SubTotal,
                @IVA = IvaTotal,
                @TotalAfectado = Total
            FROM ventas.Factura
            WHERE ID = @ID_Factura;
        END;

        -- Calcular totales afectados
        IF @ID_Producto IS NOT NULL
        BEGIN
            SET @SubtotalAfectado = @CantidadAfectada * @PrecioUnitario;
            SET @TotalAfectado = @SubtotalAfectado + (@SubtotalAfectado * @IVA);
        END;

        INSERT INTO ventas.NotaCredito (ID_Factura, ID_Cliente, ID_Producto, FechaEmision, Motivo,Comprobante)
        VALUES (@ID_Factura, @ID_Cliente, @ID_Producto, GETDATE(), @Motivo, @Comprobante);

        IF NOT EXISTS (SELECT 1 FROM ventas.DetalleFactura DF
                       WHERE DF.ID_Factura = @ID_Factura
                       AND DF.Cantidad > 0) 
        BEGIN
            UPDATE ventas.Factura
            SET Estado = 'Cancelada'
            WHERE ID = @ID_Factura;
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH
END;
GO

GO

GO
CREATE OR ALTER PROCEDURE ventas.CrearRolSupervisor
AS  
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Supervisor')
    BEGIN
        EXEC('CREATE ROLE Supervisor');
    END

    GRANT EXECUTE ON ventas.CrearNotaCredito TO Supervisor;
    GRANT SELECT ON schema::ventas TO Supervisor;
END;

GO
