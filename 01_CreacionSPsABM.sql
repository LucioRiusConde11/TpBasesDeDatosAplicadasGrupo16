DELIMITER //

-- Procedimientos para la tabla Sucursal
CREATE PROCEDURE tienda.insertarSucursal(
    IN ubicacion VARCHAR(100),
    IN ciudad VARCHAR(50)
)
BEGIN
    INSERT INTO tienda.Sucursal (Ubicacion, Ciudad) 
    VALUES (ubicacion, ciudad);
END //

CREATE PROCEDURE tienda.actualizarSucursal(
    IN sucursalID INT, 
    IN nuevaUbicacion VARCHAR(100),
    IN nuevaCiudad VARCHAR(50)
)
BEGIN
    UPDATE tienda.Sucursal 
    SET Ubicacion = nuevaUbicacion, Ciudad = nuevaCiudad
    WHERE ID = sucursalID;
END //

CREATE PROCEDURE tienda.eliminarSucursal(IN sucursalID INT)
BEGIN
    DELETE FROM tienda.Sucursal WHERE ID = sucursalID;
END //

-- Procedimientos para la tabla Empleado
CREATE PROCEDURE tienda.insertarEmpleado(
    IN nombre VARCHAR(100),
    IN apellido VARCHAR(100),
    IN dni VARCHAR(20),
    IN cargo VARCHAR(50),
    IN turno VARCHAR(5),
    IN sucursalID INT
)
BEGIN
    INSERT INTO tienda.Empleado 
        (Nombre, Apellido, DNI, Cargo, Turno, ID_Sucursal, Estado) 
    VALUES 
        (nombre, apellido, dni, cargo, turno, sucursalID, 1);
END //

CREATE PROCEDURE tienda.actualizarEmpleado(
    IN empleadoID INT,
    IN nuevoNombre VARCHAR(100),
    IN nuevoApellido VARCHAR(100),
    IN nuevoDNI VARCHAR(20),
    IN nuevoCargo VARCHAR(50),
    IN nuevoTurno VARCHAR(5),
    IN nuevaSucursalID INT
)
BEGIN
    UPDATE tienda.Empleado 
    SET Nombre = nuevoNombre, Apellido = nuevoApellido, DNI = nuevoDNI, 
        Cargo = nuevoCargo, Turno = nuevoTurno, ID_Sucursal = nuevaSucursalID
    WHERE ID = empleadoID;
END //

CREATE PROCEDURE tienda.desactivarEmpleado(IN empleadoID INT)
BEGIN
    UPDATE tienda.Empleado SET Estado = 0 WHERE ID = empleadoID;
END //

-- Procedimientos para la tabla Cliente
CREATE PROCEDURE tienda.insertarCliente(
    IN nombre VARCHAR(100),
    IN tipoCliente VARCHAR(6),
    IN genero VARCHAR(6),
    IN ciudad VARCHAR(50)
)
BEGIN
    INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Ciudad, Estado) 
    VALUES (nombre, tipoCliente, genero, ciudad, 1);
END //

CREATE PROCEDURE tienda.actualizarCliente(
    IN clienteID INT,
    IN nuevoNombre VARCHAR(100),
    IN nuevoTipoCliente VARCHAR(6),
    IN nuevoGenero VARCHAR(6),
    IN nuevaCiudad VARCHAR(50)
)
BEGIN
    UPDATE tienda.Cliente 
    SET Nombre = nuevoNombre, TipoCliente = nuevoTipoCliente, Genero = nuevoGenero, Ciudad = nuevaCiudad 
    WHERE ID = clienteID;
END //

CREATE PROCEDURE tienda.desactivarCliente(IN clienteID INT)
BEGIN
    UPDATE tienda.Cliente SET Estado = 0 WHERE ID = clienteID;
END //

-- Procedimientos para la tabla Producto
CREATE PROCEDURE catalogo.insertarProducto(
    IN nombre VARCHAR(100), 
    IN clasificacionProducto VARCHAR(100),
    IN lineaProducto VARCHAR(50),
    IN precio DECIMAL(10, 2)
)
BEGIN
    INSERT INTO catalogo.Producto (Nombre, ClasificacionProducto, LineaProducto, PrecioUnitario) 
    VALUES (nombre, clasificacionProducto, lineaProducto, precio);
END //

CREATE PROCEDURE catalogo.actualizarProducto(
    IN productoID INT,
    IN nuevoNombre VARCHAR(100),
    IN nuevaClasificacionProducto VARCHAR(100),
    IN nuevaLineaProducto VARCHAR(50),
    IN nuevoPrecio DECIMAL(10, 2)
)
BEGIN
    UPDATE catalogo.Producto 
    SET Nombre = nuevoNombre, ClasificacionProducto = nuevaClasificacionProducto,
        LineaProducto = nuevaLineaProducto, PrecioUnitario = nuevoPrecio
    WHERE ID = productoID;
END //

CREATE PROCEDURE catalogo.eliminarProducto(IN productoID INT)
BEGIN
    DELETE FROM catalogo.Producto WHERE ID = productoID;
END //

-- Procedimientos para la tabla MedioPago
CREATE PROCEDURE ventas.insertarMedioPago(IN descripcion VARCHAR(50))
BEGIN
    INSERT INTO ventas.MedioPago (Descripcion) VALUES (descripcion);
END //

CREATE PROCEDURE ventas.actualizarMedioPago(IN medioPagoID INT, IN nuevaDescripcion VARCHAR(50))
BEGIN
    UPDATE ventas.MedioPago 
    SET Descripcion = nuevaDescripcion 
    WHERE ID = medioPagoID;
END //

CREATE PROCEDURE ventas.eliminarMedioPago(IN medioPagoID INT)
BEGIN
    DELETE FROM ventas.MedioPago WHERE ID = medioPagoID;
END //

-- Procedimientos para la tabla Factura
CREATE PROCEDURE ventas.insertarFactura(
    IN fecha DATETIME, 
    IN clienteID INT, 
    IN empleadoID INT, 
    IN sucursalID INT, 
    IN medioPagoID INT
)
BEGIN
    INSERT INTO ventas.Factura (FechaHora, ID_Cliente, ID_Empleado, ID_Sucursal, ID_MedioPago) 
    VALUES (fecha, clienteID, empleadoID, sucursalID, medioPagoID);
END //

CREATE PROCEDURE ventas.actualizarFactura(
    IN facturaID INT, 
    IN nuevaFecha DATETIME, 
    IN nuevoClienteID INT, 
    IN nuevoEmpleadoID INT, 
    IN nuevaSucursalID INT, 
    IN nuevoMedioPagoID INT
)
BEGIN
    UPDATE ventas.Factura 
    SET FechaHora = nuevaFecha, ID_Cliente = nuevoClienteID, ID_Empleado = nuevoEmpleadoID,
        ID_Sucursal = nuevaSucursalID, ID_MedioPago = nuevoMedioPagoID
    WHERE ID = facturaID;
END //

-- Procedimientos para la tabla DetalleFactura
CREATE PROCEDURE ventas.insertarDetalleFactura(
    IN facturaID INT,
    IN productoID INT,
    IN cantidad INT,
    IN precioUnitario DECIMAL(10, 2)
)
BEGIN
    INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario) 
    VALUES (facturaID, productoID, cantidad, precioUnitario);
END //

CREATE PROCEDURE ventas.actualizarDetalleFactura(
    IN detalleFacturaID INT,
    IN nuevaCantidad INT,
    IN nuevoPrecioUnitario DECIMAL(10, 2)
)
BEGIN
    UPDATE ventas.DetalleFactura 
    SET Cantidad = nuevaCantidad, PrecioUnitario = nuevoPrecioUnitario
    WHERE ID = detalleFacturaID;
END //

CREATE PROCEDURE ventas.eliminarDetalleFactura(IN detalleFacturaID INT)
BEGIN
    DELETE FROM ventas.DetalleFactura WHERE ID = detalleFacturaID;
END //

DELIMITER ;
