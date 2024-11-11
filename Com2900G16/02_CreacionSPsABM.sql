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
        PRINT ('Error: La direcci�n de la sucursal ya existe.');
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
        PRINT ('Error: La direcci�n de la sucursal ya existe.');
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
        PRINT ('Error: Tipo de cliente inv�lido.');
        RETURN;
    END

    IF @Genero NOT IN ('Female', 'Male')
    BEGIN
        PRINT ('Error: G�nero inv�lido.');
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
        PRINT ('Error: Tipo de cliente inv�lido.');
        RETURN;
    END

    IF @Genero NOT IN ('Female', 'Male')
    BEGIN
        PRINT ('Error: G�nero inv�lido.');
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
        PRINT ('Error: La categor�a ya existe.');
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
        PRINT ('Error: La categor�a ya existe.');
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
        PRINT ('Error: Estado inv�lido.');
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
        PRINT ('Error: Estado inv�lido.');
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

CREATE OR ALTER PROCEDURE LimpiarTodasLasTablas
AS
BEGIN
    IF OBJECT_ID('ventas.DetalleFactura') IS NOT NULL
        DELETE FROM ventas.DetalleFactura;

    IF OBJECT_ID('ventas.NotaCredito') IS NOT NULL
        DELETE FROM ventas.NotaCredito;

    IF OBJECT_ID('ventas.Factura') IS NOT NULL
        DELETE FROM ventas.Factura;

    IF OBJECT_ID('catalogo.Producto') IS NOT NULL
        DELETE FROM catalogo.Producto;

    IF OBJECT_ID('tienda.Empleado') IS NOT NULL
        DELETE FROM tienda.Empleado;

    IF OBJECT_ID('tienda.Cliente') IS NOT NULL
        DELETE FROM tienda.Cliente;

    IF OBJECT_ID('ventas.MedioPago') IS NOT NULL
        DELETE FROM ventas.MedioPago;

    IF OBJECT_ID('catalogo.CategoriaProducto') IS NOT NULL
        DELETE FROM catalogo.CategoriaProducto;

    IF OBJECT_ID('tienda.Sucursal') IS NOT NULL
        DELETE FROM tienda.Sucursal;

    PRINT 'Limpieza de todas las tablas completada.';
END;
GO

