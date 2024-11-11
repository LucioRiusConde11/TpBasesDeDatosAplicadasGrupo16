USE Com2900G16;
-- 1. Creaci�n de datos de prueba para las tablas necesarias
INSERT INTO tienda.Sucursal (Direccion, Ciudad, Ciudad_anterior)
VALUES ('Calle Falsa 123', 'Ciudad Prueba', NULL);
INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Estado)
VALUES ('Juan Perez', 'Normal', 'M', 1);
INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
VALUES ('000001', 'Carlos', 'Gomez', '12345678', 'carlos.gomez@empresa.com', '20-12345678-9', 'Supervisor', 'TM', 1, 1);
INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
VALUES ('L�nea Hogar', 'Electrodom�sticos');
INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
VALUES ('Licuadora', 1, 5000.00, 5000.00, 'Unidad', GETDATE());
INSERT INTO ventas.MedioPago (Descripcion_ESP, Descripcion_ENG)
VALUES ('Efectivo', 'Cash');
INSERT INTO ventas.Factura (FechaHora, Estado, ID_Cliente, ID_Empleado, ID_Sucursal, ID_MedioPago, PuntoDeVenta, Comprobante, id_factura_importado)
VALUES (GETDATE(), 'Pagada', 1, 1, 1, 1, 'P0001', 1, 'F-001');
INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario, IdentificadorPago)
VALUES (1, 1, 1, 5000.00, 'P-001');

-- 2. Creaci�n de los usuarios y asignaci�n de roles
EXEC ventas.CrearRolSupervisor

CREATE USER SupervisorUser WITHOUT LOGIN;
EXEC sp_addrolemember 'Supervisor', 'SupervisorUser';

-- Crear usuario sin permisos para crear notas de cr�dito
CREATE USER EmpleadoUser WITHOUT LOGIN;

-- 3. Pruebas de ejecuci�n del procedimiento ventas.CrearNotaCredito

-- Asignaci�n de contexto a SupervisorUser y ejecuci�n del procedimiento
EXECUTE AS USER = 'SupervisorUser';

PRINT 'Intentando crear nota de cr�dito como Supervisor:';
EXEC ventas.CrearNotaCredito 
    @ID_Factura = 1, 
    @ID_Producto = 1, 
    @IdCliente = 1, 
    @Motivo = 'Devoluci�n de producto defectuoso',
	@PuntoDeVenta = 1,
	@Comprobante = 10000;
REVERT;

-- Intento de ejecuci�n del procedimiento como usuario sin permisos (EmpleadoUser)
EXECUTE AS USER = 'EmpleadoUser';

PRINT 'Intentando crear nota de cr�dito como Empleado sin permisos:';
EXEC ventas.CrearNotaCredito 
    @ID_Factura = 1, 
    @ID_Producto = 1, 
    @IdCliente = 1, 
    @Motivo = 'Devoluci�n de producto defectuoso',
	@PuntoDeVenta = 1,
	@Comprobante = 10000;
REVERT;

EXECUTE AS USER = 'SupervisorUser';

SELECT * FROM ventas.NotaCredito