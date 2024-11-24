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
CREATE OR ALTER PROCEDURE ventas.CrearNotaCredito
    @ID_Factura INT,
    @ID_Producto INT,
	@IdCliente INT,
    @Motivo VARCHAR(255),
	@PuntoDeVenta CHAR(5),
	@Comprobante INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM ventas.Factura AS f
        JOIN ventas.DetalleFactura AS df ON f.ID = df.ID_Factura
        WHERE f.ID = @ID_Factura 
		  AND f.ID = @idCliente
          AND df.ID_Producto = @ID_Producto
		  AND f.Estado = 'Pagada' 
    )
    BEGIN
        BEGIN TRANSACTION;
        
        BEGIN TRY
            INSERT INTO ventas.NotaCredito (ID_Factura, ID_Cliente, ID_Producto, Motivo,PuntoDeVenta,Comprobante)
            VALUES (@ID_Factura,@IdCliente, @ID_Producto, @Motivo,@PuntoDeVenta,@Comprobante);

            UPDATE ventas.DetalleFactura
            SET PrecioUnitario = 0
            WHERE ID_Factura = @ID_Factura
              AND ID_Producto = @ID_Producto;

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            RAISERROR('Error al crear la nota de crédito o al actualizar el detalle de la factura.', 16, 1);
        END CATCH;
    END
    ELSE
        RAISERROR('Error: No existe una factura con el producto especificado para el cliente.', 16, 1);
END;
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
