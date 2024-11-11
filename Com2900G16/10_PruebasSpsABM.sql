USE Com2900G16;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE SUCURSAL
-- 1. Probando el procedimiento AltaSucursal: Inserción correcta.
PRINT 'Probando AltaSucursal - Inserción Correcta';
SELECT * FROM tienda.Sucursal;
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
SELECT * FROM tienda.Sucursal;
REVERT;

-- 2. Probando AltaSucursal: Inserción duplicada (error de validación).
PRINT 'Probando AltaSucursal - Error de Validación por Dirección Duplicada';
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba', @Ciudad_anterior = 'Ciudad Ant';
SELECT * FROM tienda.Sucursal;
REVERT;

-- 3. Probando BajaSucursal: Eliminación correcta.
PRINT 'Probando BajaSucursal - Eliminación Correcta';
EXEC tienda.BajaSucursal @ID = 1;
SELECT * FROM tienda.Sucursal;
REVERT;

-- 4. Probando ModificarSucursal: Actualización correcta.
PRINT 'Probando ModificarSucursal - Actualización Correcta';
EXEC tienda.AltaSucursal @Direccion = 'Calle Nueva 123', @Ciudad = 'Ciudad Nueva';
EXEC tienda.ModificarSucursal @ID = 2, @Direccion = 'Calle Nueva 124', @Ciudad = 'Ciudad Nueva Modificada', @Ciudad_anterior = 'Ciudad Nueva';
SELECT * FROM tienda.Sucursal;
REVERT;

-- 5. Probando ModificarSucursal: Validación de dirección duplicada.
PRINT 'Probando ModificarSucursal - Error de Validación por Dirección Duplicada';
EXEC tienda.ModificarSucursal @ID = 2, @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba';
SELECT * FROM tienda.Sucursal;
REVERT;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE EMPLEADO

-- 1. Probando AltaEmpleado: Inserción correcta.
PRINT 'Probando AltaEmpleado - Inserción Correcta';
SELECT * FROM tienda.Empleado;
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Ana', @Apellido = 'Lopez', @DNI = '87654321',
    @Mail_Empresa = 'ana.lopez@empresa.com', @CUIL = '27-87654321-9', @Cargo = 'Vendedor', @Turno = 'TT', @ID_Sucursal = 1, @Estado = 1;
SELECT * FROM tienda.Empleado;
REVERT;

-- 2. Probando AltaEmpleado: Legajo duplicado (error de validación).
PRINT 'Probando AltaEmpleado - Error de Validación por Legajo Duplicado';
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Pedro', @Apellido = 'Martinez', @DNI = '12341234',
    @Mail_Empresa = 'pedro.martinez@empresa.com', @CUIL = '20-12341234-5', @Cargo = 'Supervisor', @Turno = 'TM', @ID_Sucursal = 1, @Estado = 1;
SELECT * FROM tienda.Empleado;
REVERT;

-- 3. Probando BajaEmpleado: Eliminación correcta.
PRINT 'Probando BajaEmpleado - Eliminación Correcta';
EXEC tienda.BajaEmpleado @ID = 2;
SELECT * FROM tienda.Empleado;
REVERT;

-- 4. Probando ModificarEmpleado: Actualización correcta.
PRINT 'Probando ModificarEmpleado - Actualización Correcta';
EXEC tienda.AltaEmpleado @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '12398765',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 1, @Estado = 1;
EXEC tienda.ModificarEmpleado @ID = 3, @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Perez', @DNI = '12398765',
    @Mail_Empresa = 'luis.perez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TM', @ID_Sucursal = 1, @Estado = 1;
SELECT * FROM tienda.Empleado;
REVERT;

-- 5. Probando ModificarEmpleado: Validación de legajo duplicado.
PRINT 'Probando ModificarEmpleado - Error de Validación por Legajo Duplicado';
EXEC tienda.ModificarEmpleado @ID = 3, @Legajo = '000002', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '98765432',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-98765432-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 1, @Estado = 1;
SELECT * FROM tienda.Empleado;
REVERT;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CLIENTE

-- 1. Probando AltaCliente: Inserción correcta.
PRINT 'Probando AltaCliente - Inserción Correcta';
SELECT * FROM tienda.Cliente;
EXEC tienda.AltaCliente @Nombre = 'Laura Garcia', @TipoCliente = 'Member', @Genero = 'Female', @Estado = 1;
SELECT * FROM tienda.Cliente;
REVERT;

-- 2. Probando AltaCliente: TipoCliente inválido (error de validación).
PRINT 'Probando AltaCliente - Error de Validación por TipoCliente Inválido';
EXEC tienda.AltaCliente @Nombre = 'Laura Martinez', @TipoCliente = 'VIP', @Genero = 'Female', @Estado = 1;
SELECT * FROM tienda.Cliente;
REVERT;

-- 3. Probando BajaCliente: Eliminación correcta.
PRINT 'Probando BajaCliente - Eliminación Correcta';
EXEC tienda.BajaCliente @ID = 1;
SELECT * FROM tienda.Cliente;
REVERT;

-- 4. Probando ModificarCliente: Actualización correcta.
PRINT 'Probando ModificarCliente - Actualización Correcta';
EXEC tienda.AltaCliente @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'Male', @Estado = 1;
EXEC tienda.ModificarCliente @ID = 2, @Nombre = 'Andres Gomez', @TipoCliente = 'Normal', @Genero = 'Male', @Estado = 0;
SELECT * FROM tienda.Cliente;
REVERT;

-- 5. Probando ModificarCliente: Genero inválido (error de validación).
PRINT 'Probando ModificarCliente - Error de Validación por Genero Inválido';
EXEC tienda.ModificarCliente @ID = 2, @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'Other', @Estado = 1;
SELECT * FROM tienda.Cliente;
REVERT;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CATEGORIA DE PRODUCTO

-- 1. Probando AltaCategoriaProducto: Inserción correcta.
PRINT 'Probando AltaCategoriaProducto - Inserción Correcta';
SELECT * FROM catalogo.CategoriaProducto;
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Jardín', @Categoria = 'Muebles de Jardín';
SELECT * FROM catalogo.CategoriaProducto;
REVERT;

-- 2. Probando AltaCategoriaProducto: Categoría duplicada (error de validación).
PRINT 'Probando AltaCategoriaProducto - Error de Validación por Categoría Duplicada';
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Cocina', @Categoria = 'Electrodomésticos';
SELECT * FROM catalogo.CategoriaProducto;
REVERT;

-- 3. Probando BajaCategoriaProducto: Eliminación correcta.
PRINT 'Probando BajaCategoriaProducto - Eliminación Correcta';
EXEC catalogo.BajaCategoriaProducto @ID = 1;
SELECT * FROM catalogo.CategoriaProducto;
REVERT;

-- 4. Probando ModificarCategoriaProducto: Actualización correcta.
PRINT 'Probando ModificarCategoriaProducto - Actualización Correcta';
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Oficina', @Categoria = 'Muebles de Oficina';
EXEC catalogo.ModificarCategoriaProducto @ID = 2, @LineaProducto = 'Línea Oficina', @Categoria = 'Sillas de Oficina';
SELECT * FROM catalogo.CategoriaProducto;
REVERT;

-- 5. Probando ModificarCategoriaProducto: Validación de categoría duplicada.
PRINT 'Probando ModificarCategoriaProducto - Error de Validación por Categoría Duplicada';
EXEC catalogo.ModificarCategoriaProducto @ID = 2, @LineaProducto = 'Línea Hogar', @Categoria = 'Electrodomésticos';
SELECT * FROM catalogo.CategoriaProducto;
REVERT;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE PRODUCTO

-- 1. Probando AltaProducto: Inserción correcta.
PRINT 'Probando AltaProducto - Inserción Correcta';
SELECT * FROM catalogo.Producto;
EXEC catalogo.AltaProducto 
    @Nombre = 'Batidora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 3000.00, 
    @PrecioReferencia = 3000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = GETDATE();
SELECT * FROM catalogo.Producto;
REVERT;

-- 2. Probando AltaProducto: PrecioUnitario inválido (error de validación).
PRINT 'Probando AltaProducto - Error de Validación por PrecioUnitario Inválido';
EXEC catalogo.AltaProducto 
    @Nombre = 'Tostadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = -1000.00,  -- Precio inválido
    @PrecioReferencia = 1000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = GETDATE();
SELECT * FROM catalogo.Producto;
REVERT;

-- 3. Probando BajaProducto: Eliminación correcta.
PRINT 'Probando BajaProducto - Eliminación Correcta';
EXEC catalogo.BajaProducto @ID = 2;  -- Asumiendo que ID 2 corresponde a 'Batidora'
SELECT * FROM catalogo.Producto;
REVERT;

-- 4. Probando ModificarProducto: Actualización correcta.
PRINT 'Probando ModificarProducto - Actualización Correcta';
EXEC catalogo.AltaProducto 
    @Nombre = 'Lavadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 8000.00, 
    @PrecioReferencia = 8000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = GETDATE();
EXEC catalogo.ModificarProducto 
    @ID = 3,  -- Asumiendo que ID 3 corresponde a 'Lavadora'
    @Nombre = 'Lavadora Blanca', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 8500.00, 
    @PrecioReferencia = 8500.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = GETDATE();
SELECT * FROM catalogo.Producto;
REVERT;

-- 5. Probando ModificarProducto: PrecioUnitario inválido (error de validación).
PRINT 'Probando ModificarProducto - Error de Validación por PrecioUnitario Inválido';
EXEC catalogo.ModificarProducto 
    @ID = 3,  -- Asumiendo que ID 3 corresponde a 'Lavadora Blanca'
    @Nombre = 'Lavadora Blanca', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 0.00,  -- Precio inválido
    @PrecioReferencia = 8500.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = GETDATE();
SELECT * FROM catalogo.Producto;
REVERT;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE MEDIOPAGO

-- 1. Probando AltaMedioPago: Inserción correcta.
PRINT 'Probando AltaMedioPago - Inserción Correcta';
SELECT * FROM ventas.MedioPago;
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Tarjeta de Crédito', 
    @Descripcion_ENG = 'Credit Card';
SELECT * FROM ventas.MedioPago;
REVERT;

-- 2. Probando AltaMedioPago: Inserción duplicada (error de validación).
PRINT 'Probando AltaMedioPago - Error de Validación por MedioPago Duplicado';
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Cash';  -- Ya existe
SELECT * FROM ventas.MedioPago;
REVERT;

-- 3. Probando BajaMedioPago: Eliminación correcta.
PRINT 'Probando BajaMedioPago - Eliminación Correcta';
EXEC ventas.BajaMedioPago @ID = 2;  -- Asumiendo que ID 2 corresponde a 'Tarjeta de Crédito'
SELECT * FROM ventas.MedioPago;
REVERT;

-- 4. Probando ModificarMedioPago: Actualización correcta.
PRINT 'Probando ModificarMedioPago - Actualización Correcta';
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Transferencia Bancaria', 
    @Descripcion_ENG = 'Bank Transfer';
EXEC ventas.ModificarMedioPago 
    @ID = 3,  -- Asumiendo que ID 3 corresponde a 'Transferencia Bancaria'
    @Descripcion_ESP = 'Transferencia Electrónica', 
    @Descripcion_ENG = 'Electronic Transfer';
SELECT * FROM ventas.MedioPago;
REVERT;

-- 5. Probando ModificarMedioPago: Inserción duplicada (error de validación).
PRINT 'Probando ModificarMedioPago - Error de Validación por MedioPago Duplicado';
EXEC ventas.ModificarMedioPago 
    @ID = 3,  -- Asumiendo que ID 3 corresponde a 'Transferencia Electrónica'
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Cash';  -- Ya existe
SELECT * FROM ventas.MedioPago;
REVERT;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE FACTURA

-- 1. Probando AltaFactura: Inserción correcta.
PRINT 'Probando AltaFactura - Inserción Correcta';
SELECT * FROM ventas.Factura;
EXEC ventas.AltaFactura 
    @FechaHora = GETDATE(), 
    @Estado = 'Pagada', 
    @ID_Cliente = 2,  -- Asumiendo que ID 2 corresponde a 'Andres Gomez'
    @ID_Empleado = 3,  -- Asumiendo que ID 3 corresponde a 'Luis'
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-002', 
    @PuntoDeVenta = 'P0002', 
    @Comprobante = 2;
SELECT * FROM ventas.Factura;
REVERT;

-- 2. Probando AltaFactura: Estado inválido (error de validación).
PRINT 'Probando AltaFactura - Error de Validación por Estado Inválido';
EXEC ventas.AltaFactura 
    @FechaHora = GETDATE(), 
    @Estado = 'Pendiente',  -- Estado inválido
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-003', 
    @PuntoDeVenta = 'P0003', 
    @Comprobante = 3;
SELECT * FROM ventas.Factura;
REVERT;

-- 3. Probando BajaFactura: Eliminación correcta.
PRINT 'Probando BajaFactura - Eliminación Correcta';
EXEC ventas.BajaFactura @ID = 1;  -- Asumiendo que ID 1 corresponde a la primera factura
SELECT * FROM ventas.Factura;
REVERT;

-- 4. Probando ModificarFactura: Actualización correcta.
PRINT 'Probando ModificarFactura - Actualización Correcta';
EXEC ventas.AltaFactura 
    @FechaHora = GETDATE(), 
    @Estado = 'Pagada', 
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-004', 
    @PuntoDeVenta = 'P0004', 
    @Comprobante = 4;
EXEC ventas.ModificarFactura 
    @ID = 2,  -- Asumiendo que ID 2 corresponde a la factura 'F-002'
    @FechaHora = GETDATE(), 
    @Estado = 'No pagada', 
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-002-A', 
    @PuntoDeVenta = 'P0002', 
    @Comprobante = 5;
SELECT * FROM ventas.Factura;
REVERT;

-- 5. Probando ModificarFactura: Estado inválido (error de validación).
PRINT 'Probando ModificarFactura - Error de Validación por Estado Inválido';
EXEC ventas.ModificarFactura 
    @ID = 2,  -- Asumiendo que ID 2 corresponde a la factura 'F-002-A'
    @FechaHora = GETDATE(), 
    @Estado = 'Cancelada',  -- Estado inválido
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-002-B', 
    @PuntoDeVenta = 'P0002', 
    @Comprobante = 6;
SELECT * FROM ventas.Factura;
REVERT;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE DETALLEFACTURA

-- 1. Probando AltaDetalleFactura: Inserción correcta.
PRINT 'Probando AltaDetalleFactura - Inserción Correcta';
SELECT * FROM ventas.DetalleFactura;
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 3,  -- Asumiendo que ID 3 corresponde a 'F-004'
    @ID_Producto = 3,  -- Asumiendo que ID 3 corresponde a 'Lavadora Blanca'
    @Cantidad = 2, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-002';
SELECT * FROM ventas.DetalleFactura;
REVERT;

-- 2. Probando AltaDetalleFactura: Cantidad inválida (error de validación).
PRINT 'Probando AltaDetalleFactura - Error de Validación por Cantidad Inválida';
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 3,  
    @ID_Producto = 3,  
    @Cantidad = 0,  -- Cantidad inválida
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-003';
SELECT * FROM ventas.DetalleFactura;
REVERT;

-- 3. Probando BajaDetalleFactura: Eliminación correcta.
PRINT 'Probando BajaDetalleFactura - Eliminación Correcta';
EXEC ventas.BajaDetalleFactura @ID = 1;  -- Asumiendo que ID 1 corresponde al primer detalle
SELECT * FROM ventas.DetalleFactura;
REVERT;

-- 4. Probando ModificarDetalleFactura: Actualización correcta.
PRINT 'Probando ModificarDetalleFactura - Actualización Correcta';
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 3,  
    @ID_Producto = 3,  
    @Cantidad = 1, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-004';
EXEC ventas.ModificarDetalleFactura 
    @ID = 2,  -- Asumiendo que ID 2 corresponde al segundo detalle
    @ID_Factura = 3,  
    @ID_Producto = 3,  
    @Cantidad = 3, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-005';
SELECT * FROM ventas.DetalleFactura;
REVERT;

-- 5. Probando ModificarDetalleFactura: Cantidad inválida (error de validación).
PRINT 'Probando ModificarDetalleFactura - Error de Validación por Cantidad Inválida';
EXEC ventas.ModificarDetalleFactura 
    @ID = 2,  
    @ID_Factura = 3,  
    @ID_Producto = 3,  
    @Cantidad = -1,  -- Cantidad inválida
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-006';
SELECT * FROM ventas.DetalleFactura;
REVERT;

