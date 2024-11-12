USE Com2900G16;
EXEC informe.LimpiarTodasLasTablas;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE SUCURSAL
-- 1. Probando el procedimiento AltaSucursal: Inserci�n correcta.
PRINT 'Probando AltaSucursal - Inserci�n Correcta';
SELECT * FROM tienda.Sucursal;
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
SELECT * FROM tienda.Sucursal;

-- 2. Probando AltaSucursal: Inserci�n duplicada (error de validaci�n).
PRINT 'Probando AltaSucursal - Error de Validaci�n por Direcci�n Duplicada';
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba', @Ciudad_anterior = 'Ciudad Ant';
SELECT * FROM tienda.Sucursal;

-- 3. Probando BajaSucursal: Eliminaci�n correcta.
PRINT 'Probando BajaSucursal - Eliminaci�n Correcta';
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
EXEC tienda.BajaSucursal @ID = 2;
SELECT * FROM tienda.Sucursal;

-- 4. Probando ModificarSucursal: Actualizaci�n correcta.
PRINT 'Probando ModificarSucursal - Actualizaci�n Correcta';
EXEC tienda.AltaSucursal @Direccion = 'Calle Nueva 123', @Ciudad = 'Ciudad Nueva';
EXEC tienda.ModificarSucursal @ID = 3, @Direccion = 'Calle Nueva 124', @Ciudad = 'Ciudad Nueva Modificada', @Ciudad_anterior = 'Ciudad Nueva';
SELECT * FROM tienda.Sucursal;

-- 5. Probando ModificarSucursal: Validaci�n de direcci�n duplicada.
PRINT 'Probando ModificarSucursal - Error de Validaci�n por Direcci�n Duplicada';
EXEC tienda.ModificarSucursal @ID = 3, @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba';
SELECT * FROM tienda.Sucursal;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE EMPLEADO

-- 1. Probando AltaEmpleado: Inserci�n correcta.
PRINT 'Probando AltaEmpleado - Inserci�n Correcta';
SELECT * FROM tienda.Empleado;
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Ana', @Apellido = 'Lopez', @DNI = '87654321',
    @Mail_Empresa = 'ana.lopez@empresa.com', @CUIL = '27-87654321-9', @Cargo = 'Vendedor', @Turno = 'TT', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 2. Probando AltaEmpleado: Legajo duplicado (error de validaci�n).
PRINT 'Probando AltaEmpleado - Error de Validaci�n por Legajo Duplicado';
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Pedro', @Apellido = 'Martinez', @DNI = '12341234',
    @Mail_Empresa = 'pedro.martinez@empresa.com', @CUIL = '20-12341234-5', @Cargo = 'Supervisor', @Turno = 'TM', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 3. Probando BajaEmpleado: Eliminaci�n correcta.
PRINT 'Probando BajaEmpleado - Eliminaci�n Correcta';
EXEC tienda.BajaEmpleado @ID = 1;
SELECT * FROM tienda.Empleado;

-- 4. Probando ModificarEmpleado: Actualizaci�n correcta.
PRINT 'Probando ModificarEmpleado - Actualizaci�n Correcta';
EXEC tienda.AltaEmpleado @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '12398765',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;
EXEC tienda.ModificarEmpleado @ID = 2, @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Perez', @DNI = '12398765',
    @Mail_Empresa = 'luis.perez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TM', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 5. Probando ModificarEmpleado: Validaci�n de legajo duplicado.
PRINT 'Probando ModificarEmpleado - Error de Validaci�n por Legajo Duplicado';
EXEC tienda.ModificarEmpleado @ID = 3, @Legajo = '000002', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '98765432',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-98765432-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 3,
	@Estado = 1;
SELECT * FROM tienda.Empleado;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CLIENTE

-- 1. Probando AltaCliente: Inserci�n correcta.
PRINT 'Probando AltaCliente - Inserci�n Correcta';
SELECT * FROM tienda.Cliente;
EXEC tienda.AltaCliente @Nombre = 'Laura Garcia', @TipoCliente = 'Member', @Genero = 'F', @Estado = 1;
SELECT * FROM tienda.Cliente;

-- 2. Probando AltaCliente: TipoCliente inv�lido (error de validaci�n).
PRINT 'Probando AltaCliente - Error de Validaci�n por TipoCliente Inv�lido';
EXEC tienda.AltaCliente @Nombre = 'Laura Martinez', @TipoCliente = 'VIP', @Genero = 'F', @Estado = 1;
SELECT * FROM tienda.Cliente;

-- 3. Probando BajaCliente: Eliminaci�n correcta.
PRINT 'Probando BajaCliente - Eliminaci�n Correcta';
EXEC tienda.BajaCliente @ID = 1;
SELECT * FROM tienda.Cliente;

-- 4. Probando ModificarCliente: Actualizaci�n correcta.
PRINT 'Probando ModificarCliente - Actualizaci�n Correcta';
EXEC tienda.AltaCliente @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'M', @Estado = 1;
SELECT * FROM tienda.Cliente;
EXEC tienda.ModificarCliente @ID = 2, @Nombre = 'Andres Gomez', @TipoCliente = 'Normal', @Genero = 'M', @Estado = 0;
SELECT * FROM tienda.Cliente;

-- 5. Probando ModificarCliente: Genero inv�lido (error de validaci�n).
PRINT 'Probando ModificarCliente - Error de Validaci�n por Genero Inv�lido';
EXEC tienda.ModificarCliente @ID = 2, @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'F', @Estado = 1;
SELECT * FROM tienda.Cliente;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CATEGORIA DE PRODUCTO

-- 1. Probando AltaCategoriaProducto: Inserci�n correcta.
PRINT 'Probando AltaCategoriaProducto - Inserci�n Correcta';
SELECT * FROM catalogo.CategoriaProducto;
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'L�nea Jard�n', @Categoria = 'Muebles de Jard�n';
SELECT * FROM catalogo.CategoriaProducto;

-- 2. Probando AltaCategoriaProducto: Categor�a duplicada (error de validaci�n).
PRINT 'Probando AltaCategoriaProducto - Error de Validaci�n por Categor�a Duplicada';
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'L�nea Cocina', @Categoria = 'Muebles de Jard�n';
SELECT * FROM catalogo.CategoriaProducto;

-- 3. Probando BajaCategoriaProducto: Eliminaci�n correcta.
PRINT 'Probando BajaCategoriaProducto - Eliminaci�n Correcta';
EXEC catalogo.BajaCategoriaProducto @ID = 1;
SELECT * FROM catalogo.CategoriaProducto;

-- 4. Probando ModificarCategoriaProducto: Actualizaci�n correcta.
PRINT 'Probando ModificarCategoriaProducto - Actualizaci�n Correcta';
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'L�nea Oficina', @Categoria = 'Muebles de Oficina';
SELECT * FROM catalogo.CategoriaProducto;
EXEC catalogo.ModificarCategoriaProducto @ID = 2, @LineaProducto = 'L�nea Oficina', @Categoria = 'Sillas de Oficina';
SELECT * FROM catalogo.CategoriaProducto;

-- 5. Probando ModificarCategoriaProducto: Validaci�n de categor�a duplicada.
PRINT 'Probando ModificarCategoriaProducto - Error de Validaci�n por Categor�a Duplicada';
EXEC catalogo.ModificarCategoriaProducto @ID = 3, @LineaProducto = 'L�nea Hogar', @Categoria = 'Sillas de Oficina';
SELECT * FROM catalogo.CategoriaProducto;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE PRODUCTO


-- 1. Probando AltaProducto: Inserci�n correcta.
PRINT 'Probando AltaProducto - Inserci�n Correcta';
Declare @date date
set @date = getdate()
SELECT * FROM catalogo.Producto;
EXEC catalogo.AltaProducto 
    @Nombre = 'Batidora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 3000.00, 
    @PrecioReferencia = 3000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date;
SELECT * FROM catalogo.Producto;

-- 2. Probando AltaProducto: PrecioUnitario inv�lido (error de validaci�n).
PRINT 'Probando AltaProducto - Error de Validaci�n por PrecioUnitario Inv�lido';
Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Tostadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = -1000.00,  -- Precio inv�lido
    @PrecioReferencia = 1000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date;
SELECT * FROM catalogo.Producto;

-- 3. Probando BajaProducto: Eliminaci�n correcta.
PRINT 'Probando BajaProducto - Eliminaci�n Correcta';
EXEC catalogo.BajaProducto @ID = 1; 
SELECT * FROM catalogo.Producto;

-- 4. Probando ModificarProducto: Actualizaci�n correcta.
PRINT 'Probando ModificarProducto - Actualizaci�n Correcta';
Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Lavadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 8000.00, 
    @PrecioReferencia = 8000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date;
SELECT * FROM catalogo.Producto;

Declare @date date
set @date = getdate()
EXEC catalogo.ModificarProducto 
    @ID = 2,  
    @Nombre = 'Lavadora Blanca', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 8500.00, 
    @PrecioReferencia = 8500.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date;
SELECT * FROM catalogo.Producto;

-- 5. Probando ModificarProducto: PrecioUnitario inv�lido (error de validaci�n).
PRINT 'Probando ModificarProducto - Error de Validaci�n por PrecioUnitario Inv�lido';
Declare @date date
set @date = getdate()
EXEC catalogo.ModificarProducto 
    @ID = 2, 
    @Nombre = 'Lavadora Blanca', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 0.00,  -- Precio inv�lido
    @PrecioReferencia = 8500.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date;
SELECT * FROM catalogo.Producto;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE MEDIOPAGO

-- 1. Probando AltaMedioPago: Inserci�n correcta.
PRINT 'Probando AltaMedioPago - Inserci�n Correcta';
SELECT * FROM ventas.MedioPago;
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Tarjeta de Cr�dito', 
    @Descripcion_ENG = 'Credit Card';
SELECT * FROM ventas.MedioPago;

-- 2. Probando AltaMedioPago: Inserci�n duplicada (error de validaci�n).
PRINT 'Probando AltaMedioPago - Error de Validaci�n por MedioPago Duplicado';
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Credit Card';  -- Ya existe
SELECT * FROM ventas.MedioPago;

-- 3. Probando BajaMedioPago: Eliminaci�n correcta.
PRINT 'Probando BajaMedioPago - Eliminaci�n Correcta';
EXEC ventas.BajaMedioPago @ID = 1; 
SELECT * FROM ventas.MedioPago;

-- 4. Probando ModificarMedioPago: Actualizaci�n correcta.
PRINT 'Probando ModificarMedioPago - Actualizaci�n Correcta';
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Transferencia Bancaria', 
    @Descripcion_ENG = 'Bank Transfer';
SELECT * FROM ventas.MedioPago;


EXEC ventas.ModificarMedioPago 
    @ID =2,  
    @Descripcion_ESP = 'Transferencia Electr�nica', 
    @Descripcion_ENG = 'Electronic Transfer';
SELECT * FROM ventas.MedioPago;

-- 5. Probando ModificarMedioPago: Inserci�n duplicada (error de validaci�n).
PRINT 'Probando ModificarMedioPago - Error de Validaci�n por MedioPago Duplicado';
EXEC ventas.ModificarMedioPago 
    @ID = 3, 
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Electronic Transfer';  
SELECT * FROM ventas.MedioPago;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE FACTURA

-- 1. Probando AltaFactura: Inserci�n correcta.
PRINT 'Probando AltaFactura - Inserci�n Correcta';
SELECT * FROM ventas.Factura;
Declare @date date
set @date = getdate()
EXEC ventas.AltaFactura 
    @FechaHora = @date, 
    @Estado = 'Pagada', 
    @ID_Cliente = 2,  
    @ID_Empleado = 2,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 2, 
    @id_factura_importado = 'F-002', 
    @PuntoDeVenta = '00002', 
    @Comprobante = 2;
SELECT * FROM ventas.Factura;

-- 2. Probando AltaFactura: Estado inv�lido (error de validaci�n).
PRINT 'Probando AltaFactura - Error de Validaci�n por Estado Inv�lido';
Declare @date date
set @date = getdate()
EXEC ventas.AltaFactura 
    @FechaHora = @date, 
    @Estado = 'Pendiente',  -- Estado inv�lido
    @ID_Cliente = 2,  
    @ID_Empleado = 2,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 2, 
    @id_factura_importado = 'F-003', 
    @PuntoDeVenta = '00003', 
    @Comprobante = 3;
SELECT * FROM ventas.Factura;

-- 3. Probando BajaFactura: Eliminaci�n correcta.
PRINT 'Probando BajaFactura - Eliminaci�n Correcta';
EXEC ventas.BajaFactura @ID = 1;  
SELECT * FROM ventas.Factura;

-- 4. Probando ModificarFactura: Actualizaci�n correcta.
PRINT 'Probando ModificarFactura - Actualizaci�n Correcta';
Declare @date date
set @date = getdate()
EXEC ventas.AltaFactura 
    @FechaHora = @date, 
    @Estado = 'Pagada', 
    @ID_Cliente = 2,  
    @ID_Empleado = 2,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 2, 
    @id_factura_importado = 'F-004', 
    @PuntoDeVenta = '00004', 
    @Comprobante = 4;
SELECT * FROM ventas.Factura;

Declare @date date
set @date = getdate()
EXEC ventas.ModificarFactura 
    @ID = 2, 
    @FechaHora = @date, 
    @Estado = 'No pagada', 
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-002-A', 
    @PuntoDeVenta = '00002', 
    @Comprobante = 5;
SELECT * FROM ventas.Factura;

-- 5. Probando ModificarFactura: Estado inv�lido (error de validaci�n).
PRINT 'Probando ModificarFactura - Error de Validaci�n por Estado Inv�lido';
Declare @date date
set @date = getdate()
EXEC ventas.ModificarFactura 
    @ID = 2, 
    @FechaHora = @date, 
    @Estado = 'Cancelada',  -- Estado inv�lido
    @ID_Cliente = 2,  
    @ID_Empleado = 3,  
    @ID_Sucursal = 2, 
    @ID_MedioPago = 3, 
    @id_factura_importado = 'F-002-B', 
    @PuntoDeVenta = 'P0002', 
    @Comprobante = 6;
SELECT * FROM ventas.Factura;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE DETALLEFACTURA

-- 1. Probando AltaDetalleFactura: Inserci�n correcta.
PRINT 'Probando AltaDetalleFactura - Inserci�n Correcta';
SELECT * FROM ventas.DetalleFactura;
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 2,  
    @ID_Producto = 2,
    @Cantidad = 2, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-002';
SELECT * FROM ventas.DetalleFactura;

-- 2. Probando AltaDetalleFactura: Cantidad inv�lida (error de validaci�n).
PRINT 'Probando AltaDetalleFactura - Error de Validaci�n por Cantidad Inv�lida';
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 2,  
    @ID_Producto = 2,  
    @Cantidad = 0,  -- Cantidad inv�lida
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-003';
SELECT * FROM ventas.DetalleFactura;

-- 3. Probando BajaDetalleFactura: Eliminaci�n correcta.
PRINT 'Probando BajaDetalleFactura - Eliminaci�n Correcta';
EXEC ventas.BajaDetalleFactura @ID = 1; 
SELECT * FROM ventas.DetalleFactura;

-- 4. Probando ModificarDetalleFactura: Actualizaci�n correcta.
PRINT 'Probando ModificarDetalleFactura - Actualizaci�n Correcta';
EXEC ventas.AltaDetalleFactura 
    @ID_Factura = 2,  
    @ID_Producto = 2,  
    @Cantidad = 1, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-004';
SELECT * FROM ventas.DetalleFactura;

EXEC ventas.ModificarDetalleFactura 
    @ID = 2,  
    @ID_Factura = 2,  
    @ID_Producto = 2,  
    @Cantidad = 3, 
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-005';
SELECT * FROM ventas.DetalleFactura;

-- 5. Probando ModificarDetalleFactura: Cantidad inv�lida (error de validaci�n).
PRINT 'Probando ModificarDetalleFactura - Error de Validaci�n por Cantidad Inv�lida';
EXEC ventas.ModificarDetalleFactura 
    @ID = 2,  
    @ID_Factura = 2,  
    @ID_Producto = 2,  
    @Cantidad = -1,  -- Cantidad inv�lida
    @PrecioUnitario = 8500.00, 
    @IdentificadorPago = 'P-006';
SELECT * FROM ventas.DetalleFactura;

REVERT;

