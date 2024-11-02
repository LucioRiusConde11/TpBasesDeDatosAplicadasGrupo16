USE Com2900G16;
GO
-- Procedimientos para el esquema tienda - Tabla Sucursal
CREATE PROCEDURE tienda.InsertarSucursal
    @Ubicacion VARCHAR(100),
    @Ciudad VARCHAR(50)
AS
BEGIN
    INSERT INTO tienda.Sucursal (Ubicacion, Ciudad)
    VALUES (@Ubicacion, @Ciudad);
END;
GO

CREATE PROCEDURE tienda.ActualizarSucursal
    @ID INT,
    @Ubicacion VARCHAR(100),
    @Ciudad VARCHAR(50)
AS
BEGIN
    UPDATE tienda.Sucursal
    SET Ubicacion = @Ubicacion, Ciudad = @Ciudad
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE tienda.EliminarSucursal
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Sucursal
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema tienda - Tabla Empleado
CREATE PROCEDURE tienda.InsertarEmpleado
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @DNI VARCHAR(20),
    @Cargo VARCHAR(50),
    @Turno VARCHAR(5),
    @ID_Sucursal INT
AS
BEGIN
    INSERT INTO tienda.Empleado (Nombre, Apellido, DNI, Cargo, Turno, ID_Sucursal)
    VALUES (@Nombre, @Apellido, @DNI, @Cargo, @Turno, @ID_Sucursal);
END;
GO

CREATE PROCEDURE tienda.ActualizarEmpleado
    @ID INT,
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @DNI VARCHAR(20),
    @Cargo VARCHAR(50),
    @Turno VARCHAR(5),
    @ID_Sucursal INT,
    @Estado BIT
AS
BEGIN
    UPDATE tienda.Empleado
    SET Nombre = @Nombre, Apellido = @Apellido, DNI = @DNI,
        Cargo = @Cargo, Turno = @Turno, ID_Sucursal = @ID_Sucursal,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE tienda.EliminarEmpleado
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Empleado
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema tienda - Tabla Cliente
CREATE PROCEDURE tienda.InsertarCliente
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero VARCHAR(6),
    @Ciudad VARCHAR(50)
AS
BEGIN
    INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Ciudad)
    VALUES (@Nombre, @TipoCliente, @Genero, @Ciudad);
END;
GO

CREATE PROCEDURE tienda.ActualizarCliente
    @ID INT,
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero VARCHAR(6),
    @Ciudad VARCHAR(50),
    @Estado BIT
AS
BEGIN
    UPDATE tienda.Cliente
    SET Nombre = @Nombre, TipoCliente = @TipoCliente, Genero = @Genero,
        Ciudad = @Ciudad, Estado = @Estado
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE tienda.EliminarCliente
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Cliente
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema catalogo - Tabla Producto
CREATE PROCEDURE catalogo.InsertarProducto
    @Nombre VARCHAR(100),
    @ClasificacionProducto VARCHAR(100),
    @LineaProducto VARCHAR(50),
    @PrecioUnitario DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO catalogo.Producto (Nombre, ClasificacionProducto, LineaProducto, PrecioUnitario)
    VALUES (@Nombre, @ClasificacionProducto, @LineaProducto, @PrecioUnitario);
END;
GO

CREATE PROCEDURE catalogo.ActualizarProducto
    @ID INT,
    @Nombre VARCHAR(100),
    @ClasificacionProducto VARCHAR(100),
    @LineaProducto VARCHAR(50),
    @PrecioUnitario DECIMAL(10, 2)
AS
BEGIN
    UPDATE catalogo.Producto
    SET Nombre = @Nombre, ClasificacionProducto = @ClasificacionProducto,
        LineaProducto = @LineaProducto, PrecioUnitario = @PrecioUnitario
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE catalogo.EliminarProducto
    @ID INT
AS
BEGIN
    DELETE FROM catalogo.Producto
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema ventas - Tabla MedioPago
CREATE PROCEDURE ventas.InsertarMedioPago
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO ventas.MedioPago (Descripcion)
    VALUES (@Descripcion);
END;
GO

CREATE PROCEDURE ventas.ActualizarMedioPago
    @ID INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE ventas.MedioPago
    SET Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE ventas.EliminarMedioPago
    @ID INT
AS
BEGIN
    DELETE FROM ventas.MedioPago
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema ventas - Tabla EstadoFactura
CREATE PROCEDURE ventas.InsertarEstadoFactura
    @Descripcion VARCHAR(10)
AS
BEGIN
    INSERT INTO ventas.EstadoFactura (Descripcion)
    VALUES (@Descripcion);
END;
GO

CREATE PROCEDURE ventas.ActualizarEstadoFactura
    @ID INT,
    @Descripcion VARCHAR(10)
AS
BEGIN
    UPDATE ventas.EstadoFactura
    SET Descripcion = @Descripcion
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE ventas.EliminarEstadoFactura
    @ID INT
AS
BEGIN
    DELETE FROM ventas.EstadoFactura
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema ventas - Tabla Factura
CREATE PROCEDURE ventas.InsertarFactura
    @FechaHora DATETIME,
    @ID_Estado INT,
    @ID_Cliente INT,
    @ID_Empleado INT,
    @ID_Sucursal INT,
    @ID_MedioPago INT
AS
BEGIN
    INSERT INTO ventas.Factura (FechaHora, ID_Estado, ID_Cliente, ID_Empleado, ID_Sucursal, ID_MedioPago)
    VALUES (@FechaHora, @ID_Estado, @ID_Cliente, @ID_Empleado, @ID_Sucursal, @ID_MedioPago);
END;
GO

CREATE PROCEDURE ventas.ActualizarFactura
    @ID INT,
    @FechaHora DATETIME,
    @ID_Estado INT,
    @ID_Cliente INT,
    @ID_Empleado INT,
    @ID_Sucursal INT,
    @ID_MedioPago INT
AS
BEGIN
    UPDATE ventas.Factura
    SET FechaHora = @FechaHora,
        ID_Estado = @ID_Estado,
        ID_Cliente = @ID_Cliente,
        ID_Empleado = @ID_Empleado,
        ID_Sucursal = @ID_Sucursal,
        ID_MedioPago = @ID_MedioPago
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE ventas.EliminarFactura
    @ID INT
AS
BEGIN
    DELETE FROM ventas.Factura
    WHERE ID = @ID;
END;
GO

-- Procedimientos para el esquema ventas - Tabla DetalleFactura
CREATE PROCEDURE ventas.InsertarDetalleFactura
    @ID_Factura INT,
    @ID_Producto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario)
    VALUES (@ID_Factura, @ID_Producto, @Cantidad, @PrecioUnitario);
END;
GO

CREATE PROCEDURE ventas.ActualizarDetalleFactura
    @ID INT,
    @ID_Factura INT,
    @ID_Producto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10, 2)
AS
BEGIN
    UPDATE ventas.DetalleFactura
    SET ID_Factura = @ID_Factura,
        ID_Producto = @ID_Producto,
        Cantidad = @Cantidad,
        PrecioUnitario = @PrecioUnitario
    WHERE ID = @ID;
END;
GO

CREATE PROCEDURE ventas.EliminarDetalleFactura
    @ID INT
AS
BEGIN
    DELETE FROM ventas.DetalleFactura
    WHERE ID = @ID;
END;
GO
