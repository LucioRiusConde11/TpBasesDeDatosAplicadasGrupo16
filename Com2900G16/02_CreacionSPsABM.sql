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
USE Com2900G16;
GO

-- Procedimientos para la Tabla Sucursal
CREATE OR ALTER PROCEDURE tienda.AltaSucursal
    @Direccion VARCHAR(100),
    @Ciudad VARCHAR(50),
    @Ciudad_anterior VARCHAR(50) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Sucursal WHERE Direccion = @Direccion)
    BEGIN
        PRINT ('Error: La dirección de la sucursal ya existe.');
        RETURN;
    END

    INSERT INTO tienda.Sucursal (Direccion, Ciudad, Ciudad_anterior)
    VALUES (@Direccion, @Ciudad, @Ciudad_anterior);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaSucursal
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Sucursal WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarSucursal
    @ID INT,
    @Direccion VARCHAR(100),
    @Ciudad VARCHAR(50),
    @Ciudad_anterior VARCHAR(50) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Sucursal WHERE Direccion = @Direccion AND ID <> @ID)
    BEGIN
        PRINT ('Error: La dirección de la sucursal ya existe.');
        RETURN;
    END

    UPDATE tienda.Sucursal
    SET Direccion = @Direccion,
        Ciudad = @Ciudad,
        Ciudad_anterior = @Ciudad_anterior
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Empleado
CREATE OR ALTER PROCEDURE tienda.AltaEmpleado
    @Legajo CHAR(6),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @DNI CHAR(8),
    @Mail_Empresa VARCHAR(100),
    @CUIL VARCHAR(13),
    @Cargo VARCHAR(20),
    @Turno CHAR(2),
    @ID_Sucursal INT,
    @Estado BIT = 1
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        RETURN;
    END

    INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
    VALUES (@Legajo, @Nombre, @Apellido, @DNI, @Mail_Empresa, @CUIL, @Cargo, @Turno, @ID_Sucursal, @Estado);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaEmpleado
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Empleado WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarEmpleado
    @ID INT,
    @Legajo CHAR(6),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @DNI CHAR(8),
    @Mail_Empresa VARCHAR(100),
    @CUIL VARCHAR(13),
    @Cargo VARCHAR(20),
    @Turno CHAR(2),
    @ID_Sucursal INT,
    @Estado BIT = 1
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo AND ID <> @ID)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        RETURN;
    END

    UPDATE tienda.Empleado
    SET Legajo = @Legajo,
        Nombre = @Nombre,
        Apellido = @Apellido,
        DNI = @DNI,
        Mail_Empresa = @Mail_Empresa,
        CUIL = @CUIL,
        Cargo = @Cargo,
        Turno = @Turno,
        ID_Sucursal = @ID_Sucursal,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Cliente
CREATE OR ALTER PROCEDURE tienda.AltaCliente
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero CHAR(1),
    @Estado BIT = 1
AS
BEGIN
    IF @TipoCliente NOT IN ('Member', 'Normal')
    BEGIN
        PRINT ('Error: Tipo de cliente inválido.');
        RETURN;
    END

    IF @Genero NOT IN ('F', 'M')
    BEGIN
        PRINT ('Error: Género inválido.');
        RETURN;
    END

    INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Estado)
    VALUES (@Nombre, @TipoCliente, @Genero, @Estado);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaCliente
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Cliente WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarCliente
    @ID INT,
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero CHAR(1),
    @Estado BIT = 1
AS
BEGIN
    IF @TipoCliente NOT IN ('Member', 'Normal')
    BEGIN
        PRINT ('Error: Tipo de cliente inválido.');
        RETURN;
    END

    IF @Genero NOT IN ('F', 'M')
    BEGIN
        PRINT ('Error: Género inválido.');
        RETURN;
    END

    UPDATE tienda.Cliente
    SET Nombre = @Nombre,
        TipoCliente = @TipoCliente,
        Genero = @Genero,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla CategoriaProducto
CREATE OR ALTER PROCEDURE catalogo.AltaCategoriaProducto
    @LineaProducto VARCHAR(40),
    @Categoria VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM catalogo.CategoriaProducto WHERE Categoria = @Categoria)
    BEGIN
        PRINT ('Error: La categoría ya existe.');
        RETURN;
    END

    INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
    VALUES (@LineaProducto, @Categoria);
END;
GO

CREATE OR ALTER PROCEDURE catalogo.BajaCategoriaProducto
    @ID INT
AS
BEGIN
    DELETE FROM catalogo.CategoriaProducto WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE catalogo.ModificarCategoriaProducto
    @ID INT,
    @LineaProducto VARCHAR(40),
    @Categoria VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM catalogo.CategoriaProducto WHERE Categoria = @Categoria AND ID <> @ID)
    BEGIN
        PRINT ('Error: La categoría ya existe.');
        RETURN;
    END

    UPDATE catalogo.CategoriaProducto
    SET LineaProducto = @LineaProducto,
        Categoria = @Categoria
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Producto
CREATE OR ALTER PROCEDURE catalogo.AltaProducto
    @Nombre VARCHAR(100),
    @ID_Categoria INT,
    @PrecioUnitario DECIMAL(10, 2),
    @PrecioReferencia DECIMAL(10, 2),
    @UnidadReferencia VARCHAR(25),
    @Fecha DATETIME
AS
BEGIN
    IF @PrecioUnitario <= 0
    BEGIN
        PRINT ('Error: Precio unitario debe ser mayor a cero.');
        RETURN;
    END

    INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
    VALUES (@Nombre, @ID_Categoria, @PrecioUnitario, @PrecioReferencia, @UnidadReferencia, @Fecha);
END;
GO

CREATE OR ALTER PROCEDURE catalogo.BajaProducto
    @ID INT
AS
BEGIN
    DELETE FROM catalogo.Producto WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE catalogo.ModificarProducto
    @ID INT,
    @Nombre VARCHAR(100),
    @ID_Categoria INT,
    @PrecioUnitario DECIMAL(10, 2),
    @PrecioReferencia DECIMAL(10, 2),
    @UnidadReferencia VARCHAR(25),
    @Fecha DATETIME
AS
BEGIN
    IF @PrecioUnitario <= 0
    BEGIN
        PRINT ('Error: Precio unitario debe ser mayor a cero.');
        RETURN;
    END

    UPDATE catalogo.Producto
    SET Nombre = @Nombre,
        ID_Categoria = @ID_Categoria,
        PrecioUnitario = @PrecioUnitario,
        PrecioReferencia = @PrecioReferencia,
        UnidadReferencia = @UnidadReferencia,
        Fecha = @Fecha
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla MedioPago
CREATE OR ALTER PROCEDURE ventas.AltaMedioPago
    @Descripcion_ESP VARCHAR(50),
    @Descripcion_ENG VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ventas.MedioPago WHERE Descripcion_ESP = @Descripcion_ESP OR Descripcion_ENG = @Descripcion_ENG)
    BEGIN
        PRINT ('Error: El medio de pago ya existe.');
        RETURN;
    END

    INSERT INTO ventas.MedioPago (Descripcion_ESP, Descripcion_ENG)
    VALUES (@Descripcion_ESP, @Descripcion_ENG);
END;
GO

CREATE OR ALTER PROCEDURE ventas.BajaMedioPago
    @ID INT
AS
BEGIN
    DELETE FROM ventas.MedioPago WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE ventas.ModificarMedioPago
    @ID INT,
    @Descripcion_ESP VARCHAR(50),
    @Descripcion_ENG VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ventas.MedioPago WHERE (Descripcion_ESP = @Descripcion_ESP OR Descripcion_ENG = @Descripcion_ENG) AND ID <> @ID)
    BEGIN
        PRINT ('Error: El medio de pago ya existe.');
        RETURN;
    END

    UPDATE ventas.MedioPago
    SET Descripcion_ESP = @Descripcion_ESP,
        Descripcion_ENG = @Descripcion_ENG
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Factura
CREATE OR ALTER PROCEDURE ventas.AltaFactura
    @FechaHora DATETIME,
    @Estado VARCHAR(10),
    @ID_Cliente INT,
    @ID_Empleado INT,
    @ID_Sucursal INT,
    @ID_MedioPago INT,
    @id_factura_importado VARCHAR(30) = NULL,
	@PuntoDeVenta CHAR(5),
	@Comprobante INT
AS
BEGIN
    IF @Estado NOT IN ('Pagada', 'No pagada')
    BEGIN
        PRINT ('Error: Estado inválido.');
        RETURN;
    END

    INSERT INTO ventas.Factura (FechaHora, Estado, ID_Cliente,
	ID_Empleado, ID_Sucursal, ID_MedioPago, id_factura_importado, PuntoDeVenta, Comprobante)
    VALUES (@FechaHora, @Estado, @ID_Cliente,
	@ID_Empleado, @ID_Sucursal, @ID_MedioPago, @id_factura_importado,@PuntoDeVenta,@Comprobante);
END;
GO

CREATE OR ALTER PROCEDURE ventas.BajaFactura
    @ID INT
AS
BEGIN
    DELETE FROM ventas.Factura WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE ventas.ModificarFactura
    @ID INT,
    @FechaHora DATETIME,
    @Estado VARCHAR(10),
    @ID_Cliente INT,
    @ID_Empleado INT,
    @ID_Sucursal INT,
    @ID_MedioPago INT,
    @id_factura_importado VARCHAR(30) = NULL,
	@PuntoDeVenta CHAR(5),
	@Comprobante INT
AS
BEGIN
    IF @Estado NOT IN ('Pagada', 'No pagada')
    BEGIN
        PRINT ('Error: Estado inválido.');
        RETURN;
    END

    UPDATE ventas.Factura
    SET FechaHora = @FechaHora,
        Estado = @Estado,
        ID_Cliente = @ID_Cliente,
        ID_Empleado = @ID_Empleado,
        ID_Sucursal = @ID_Sucursal,
        ID_MedioPago = @ID_MedioPago,
        id_factura_importado = @id_factura_importado,
		PuntoDeVenta = @PuntoDeVenta,
		Comprobante = @Comprobante
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla DetalleFactura
CREATE OR ALTER PROCEDURE ventas.AltaDetalleFactura
    @ID_Factura INT,
    @ID_Producto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10, 2),
    @IdentificadorPago VARCHAR(30)
AS
BEGIN
    IF @Cantidad <= 0
    BEGIN
        PRINT ('Error: Cantidad debe ser mayor a cero.');
        RETURN;
    END

    INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario, IdentificadorPago)
    VALUES (@ID_Factura, @ID_Producto, @Cantidad, @PrecioUnitario, @IdentificadorPago);
END;
GO

CREATE OR ALTER PROCEDURE ventas.BajaDetalleFactura
    @ID INT
AS
BEGIN
    DELETE FROM ventas.DetalleFactura WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE ventas.ModificarDetalleFactura
    @ID INT,
    @ID_Factura INT,
    @ID_Producto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10, 2),
    @IdentificadorPago VARCHAR(30)
AS
BEGIN
    IF @Cantidad <= 0
    BEGIN
        PRINT ('Error: Cantidad debe ser mayor a cero.');
        RETURN;
    END

    UPDATE ventas.DetalleFactura
    SET ID_Factura = @ID_Factura,
        ID_Producto = @ID_Producto,
        Cantidad = @Cantidad,
        PrecioUnitario = @PrecioUnitario,
        IdentificadorPago = @IdentificadorPago
    WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE informe.LimpiarTodasLasTablas
AS
BEGIN
    SET NOCOUNT ON;

    -- Desactivar restricciones de clave externa en el orden correcto
    ALTER TABLE ventas.DetalleFactura NOCHECK CONSTRAINT ALL;
    ALTER TABLE ventas.Factura NOCHECK CONSTRAINT ALL;
    ALTER TABLE ventas.MedioPago NOCHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Empleado NOCHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Cliente NOCHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Sucursal NOCHECK CONSTRAINT ALL;
    ALTER TABLE catalogo.Producto NOCHECK CONSTRAINT ALL;
    ALTER TABLE catalogo.CategoriaProducto NOCHECK CONSTRAINT ALL;

    -- Borrar datos en el orden correcto para evitar conflictos de FK
    DELETE FROM ventas.DetalleFactura;
    DELETE FROM ventas.Factura;
    DELETE FROM ventas.MedioPago;
    DELETE FROM tienda.Empleado;
    DELETE FROM tienda.Cliente;
    DELETE FROM tienda.Sucursal;
    DELETE FROM catalogo.Producto;
    DELETE FROM catalogo.CategoriaProducto;

    -- Reiniciar los contadores IDENTITY en cada tabla
    DBCC CHECKIDENT ('ventas.DetalleFactura', RESEED, 0);
    DBCC CHECKIDENT ('ventas.Factura', RESEED, 0);
    DBCC CHECKIDENT ('ventas.MedioPago', RESEED, 0);
    DBCC CHECKIDENT ('tienda.Empleado', RESEED, 0);
    DBCC CHECKIDENT ('tienda.Cliente', RESEED, 0);
    DBCC CHECKIDENT ('tienda.Sucursal', RESEED, 0);
    DBCC CHECKIDENT ('catalogo.Producto', RESEED, 0);
    DBCC CHECKIDENT ('catalogo.CategoriaProducto', RESEED, 0);

    -- Reactivar las restricciones de clave externa en el orden correcto
    ALTER TABLE ventas.DetalleFactura WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE ventas.Factura WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE ventas.MedioPago WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Empleado WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Cliente WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE tienda.Sucursal WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE catalogo.Producto WITH CHECK CHECK CONSTRAINT ALL;
    ALTER TABLE catalogo.CategoriaProducto WITH CHECK CHECK CONSTRAINT ALL;

    PRINT 'Todas las tablas han sido vaciadas y los contadores IDENTITY han sido reiniciados.';
END;
GO

