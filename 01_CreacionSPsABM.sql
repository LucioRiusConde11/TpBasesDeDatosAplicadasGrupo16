DELIMITER //

-- Procedimientos para Sucursal

CREATE PROCEDURE sp_InsertarSucursal(
    IN p_Ubicacion VARCHAR(100),
    IN p_Ciudad VARCHAR(50)
)
BEGIN
    INSERT INTO tienda.Sucursal (Ubicacion, Ciudad) VALUES (p_Ubicacion, p_Ciudad);
END //

CREATE PROCEDURE sp_ActualizarSucursal(
    IN p_ID INT,
    IN p_Ubicacion VARCHAR(100),
    IN p_Ciudad VARCHAR(50)
)
BEGIN
    UPDATE tienda.Sucursal
    SET Ubicacion = p_Ubicacion, Ciudad = p_Ciudad
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarSucursal(
    IN p_ID INT
)
BEGIN
    DELETE FROM tienda.Sucursal WHERE ID = p_ID;
END //

-- Procedimientos para Empleado

CREATE PROCEDURE sp_InsertarEmpleado(
    IN p_Nombre VARCHAR(100),
    IN p_Apellido VARCHAR(100),
    IN p_DNI VARCHAR(20),
    IN p_Cargo VARCHAR(50),
    IN p_Turno VARCHAR(5),
    IN p_ID_Sucursal INT
)
BEGIN
    INSERT INTO tienda.Empleado (Nombre, Apellido, DNI, Cargo, Turno, ID_Sucursal)
    VALUES (p_Nombre, p_Apellido, p_DNI, p_Cargo, p_Turno, p_ID_Sucursal);
END //

CREATE PROCEDURE sp_ActualizarEmpleado(
    IN p_ID INT,
    IN p_Nombre VARCHAR(100),
    IN p_Apellido VARCHAR(100),
    IN p_DNI VARCHAR(20),
    IN p_Cargo VARCHAR(50),
    IN p_Turno VARCHAR(5),
    IN p_ID_Sucursal INT,
    IN p_Estado INT
)
BEGIN
    UPDATE tienda.Empleado
    SET Nombre = p_Nombre, Apellido = p_Apellido, DNI = p_DNI, 
        Cargo = p_Cargo, Turno = p_Turno, ID_Sucursal = p_ID_Sucursal,
        Estado = p_Estado
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarEmpleado(
    IN p_ID INT
)
BEGIN
    DELETE FROM tienda.Empleado WHERE ID = p_ID;
END //

-- Procedimientos para Cliente

CREATE PROCEDURE sp_InsertarCliente(
    IN p_Nombre VARCHAR(100),
    IN p_TipoCliente VARCHAR(6),
    IN p_Genero VARCHAR(6),
    IN p_Ciudad VARCHAR(50)
)
BEGIN
    INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Ciudad)
    VALUES (p_Nombre, p_TipoCliente, p_Genero, p_Ciudad);
END //

CREATE PROCEDURE sp_ActualizarCliente(
    IN p_ID INT,
    IN p_Nombre VARCHAR(100),
    IN p_TipoCliente VARCHAR(6),
    IN p_Genero VARCHAR(6),
    IN p_Ciudad VARCHAR(50),
    IN p_Estado INT
)
BEGIN
    UPDATE tienda.Cliente
    SET Nombre = p_Nombre, TipoCliente = p_TipoCliente, Genero = p_Genero,
        Ciudad = p_Ciudad, Estado = p_Estado
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarCliente(
    IN p_ID INT
)
BEGIN
    DELETE FROM tienda.Cliente WHERE ID = p_ID;
END //

-- Procedimientos para Producto

CREATE PROCEDURE sp_InsertarProducto(
    IN p_Nombre VARCHAR(100),
    IN p_ClasificacionProducto VARCHAR(100),
    IN p_LineaProducto VARCHAR(50),
    IN p_PrecioUnitario DECIMAL(10, 2)
)
BEGIN
    INSERT INTO catalogo.Producto (Nombre, ClasificacionProducto, LineaProducto, PrecioUnitario)
    VALUES (p_Nombre, p_ClasificacionProducto, p_LineaProducto, p_PrecioUnitario);
END //

CREATE PROCEDURE sp_ActualizarProducto(
    IN p_ID INT,
    IN p_Nombre VARCHAR(100),
    IN p_ClasificacionProducto VARCHAR(100),
    IN p_LineaProducto VARCHAR(50),
    IN p_PrecioUnitario DECIMAL(10, 2)
)
BEGIN
    UPDATE catalogo.Producto
    SET Nombre = p_Nombre, ClasificacionProducto = p_ClasificacionProducto, 
        LineaProducto = p_LineaProducto, PrecioUnitario = p_PrecioUnitario
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarProducto(
    IN p_ID INT
)
BEGIN
    DELETE FROM catalogo.Producto WHERE ID = p_ID;
END //

-- Procedimientos para MedioPago

CREATE PROCEDURE sp_InsertarMedioPago(
    IN p_Descripcion VARCHAR(50)
)
BEGIN
    INSERT INTO ventas.MedioPago (Descripcion) VALUES (p_Descripcion);
END //

CREATE PROCEDURE sp_ActualizarMedioPago(
    IN p_ID INT,
    IN p_Descripcion VARCHAR(50)
)
BEGIN
    UPDATE ventas.MedioPago
    SET Descripcion = p_Descripcion
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarMedioPago(
    IN p_ID INT
)
BEGIN
    DELETE FROM ventas.MedioPago WHERE ID = p_ID;
END //

-- Procedimientos para EstadoFactura

CREATE PROCEDURE sp_InsertarEstadoFactura(
    IN p_Descripcion VARCHAR(10)
)
BEGIN
    INSERT INTO ventas.EstadoFactura (Descripcion) VALUES (p_Descripcion);
END //

CREATE PROCEDURE sp_ActualizarEstadoFactura(
    IN p_ID INT,
    IN p_Descripcion VARCHAR(10)
)
BEGIN
    UPDATE ventas.EstadoFactura
    SET Descripcion = p_Descripcion
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarEstadoFactura(
    IN p_ID INT
)
BEGIN
    DELETE FROM ventas.EstadoFactura WHERE ID = p_ID;
END //

-- Procedimientos para Factura

CREATE PROCEDURE sp_InsertarFactura(
    IN p_FechaHora DATETIME,
    IN p_ID_Estado INT,
    IN p_ID_Cliente INT,
    IN p_ID_Empleado INT,
    IN p_ID_Sucursal INT,
    IN p_ID_MedioPago INT
)
BEGIN
    INSERT INTO ventas.Factura (FechaHora, ID_Estado, ID_Cliente, ID_Empleado, ID_Sucursal, ID_MedioPago)
    VALUES (p_FechaHora, p_ID_Estado, p_ID_Cliente, p_ID_Empleado, p_ID_Sucursal, p_ID_MedioPago);
END //

CREATE PROCEDURE sp_ActualizarFactura(
    IN p_ID INT,
    IN p_FechaHora DATETIME,
    IN p_ID_Estado INT,
    IN p_ID_Cliente INT,
    IN p_ID_Empleado INT,
    IN p_ID_Sucursal INT,
    IN p_ID_MedioPago INT
)
BEGIN
    UPDATE ventas.Factura
    SET FechaHora = p_FechaHora,
        ID_Estado = p_ID_Estado,
        ID_Cliente = p_ID_Cliente,
        ID_Empleado = p_ID_Empleado,
        ID_Sucursal = p_ID_Sucursal,
        ID_MedioPago = p_ID_MedioPago
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarFactura(
    IN p_ID INT
)
BEGIN
    DELETE FROM ventas.Factura WHERE ID = p_ID;
END //

-- Procedimientos para DetalleFactura

CREATE PROCEDURE sp_InsertarDetalleFactura(
    IN p_ID_Factura INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_PrecioUnitario DECIMAL(10, 2)
)
BEGIN
    INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario)
    VALUES (p_ID_Factura, p_ID_Producto, p_Cantidad, p_PrecioUnitario);
END //

CREATE PROCEDURE sp_ActualizarDetalleFactura(
    IN p_ID INT,
    IN p_ID_Factura INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_PrecioUnitario DECIMAL(10, 2)
)
BEGIN
    UPDATE ventas.DetalleFactura
    SET ID_Factura = p_ID_Factura,
        ID_Producto = p_ID_Producto,
        Cantidad = p_Cantidad,
        PrecioUnitario = p_PrecioUnitario
    WHERE ID = p_ID;
END //

CREATE PROCEDURE sp_EliminarDetalleFactura(
    IN p_ID INT
)
BEGIN
    DELETE FROM ventas.DetalleFactura WHERE ID = p_ID;
END //

DELIMITER ;
