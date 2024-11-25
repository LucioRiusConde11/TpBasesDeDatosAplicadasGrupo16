USE Com2900G16;
EXEC informe.LimpiarTodasLasTablas;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE SUCURSAL
-- 1. Probando el procedimiento AltaSucursal: Inserción correcta.
SELECT * FROM tienda.Sucursal;
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
SELECT * FROM tienda.Sucursal;

-- 2. Probando AltaSucursal: Inserción duplicada (error de validación).
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba', @Ciudad_anterior = 'Ciudad Ant';
SELECT * FROM tienda.Sucursal;

-- 3. Probando BajaSucursal: Eliminación correcta.
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 4566', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
EXEC tienda.BajaSucursal @ID = 2;
SELECT * FROM tienda.Sucursal;

-- 4. Probando ModificarSucursal: Actualización correcta.
EXEC tienda.AltaSucursal @Direccion = 'Calle Nueva 123', @Ciudad = 'Ciudad Nueva';
EXEC tienda.ModificarSucursal @ID = 3, @Direccion = 'Calle Nueva 124', @Ciudad = 'Ciudad Nueva Modificada', @Ciudad_anterior = 'Ciudad Nueva';
SELECT * FROM tienda.Sucursal;

-- 5. Probando ModificarSucursal: Validación de dirección duplicada.
EXEC tienda.ModificarSucursal @ID = 3, @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Prueba';
SELECT * FROM tienda.Sucursal;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE EMPLEADO

-- 1. Probando AltaEmpleado: Inserción correcta.
SELECT * FROM tienda.Empleado;
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Ana', @Apellido = 'Lopez', @DNI = '87654321',
    @Mail_Empresa = 'ana.lopez@empresa.com', @CUIL = '27-87654321-9', @Cargo = 'Vendedor', @Turno = 'TT', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 2. Probando AltaEmpleado: Legajo duplicado (error de validación).
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Pedro', @Apellido = 'Martinez', @DNI = '12341234',
    @Mail_Empresa = 'pedro.martinez@empresa.com', @CUIL = '20-12341234-5', @Cargo = 'Supervisor', @Turno = 'TM', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 3. Probando BajaEmpleado: Eliminación correcta.
EXEC tienda.BajaEmpleado @ID = 1;
SELECT * FROM tienda.Empleado;

-- 4. Probando ModificarEmpleado: Actualización correcta.
EXEC tienda.AltaEmpleado @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '12398765',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;
EXEC tienda.ModificarEmpleado @ID = 2, @Legajo = '000003', @Nombre = 'Luis', @Apellido = 'Perez', @DNI = '12398765',
    @Mail_Empresa = 'luis.perez@empresa.com', @CUIL = '20-12398765-5', @Cargo = 'Gerente', @Turno = 'TM', @ID_Sucursal = 3, @Estado = 1;
SELECT * FROM tienda.Empleado;

-- 5. Probando ModificarEmpleado: Validación de legajo duplicado.
EXEC tienda.ModificarEmpleado @ID = 3, @Legajo = '000002', @Nombre = 'Luis', @Apellido = 'Sanchez', @DNI = '98765432',
    @Mail_Empresa = 'luis.sanchez@empresa.com', @CUIL = '20-98765432-5', @Cargo = 'Gerente', @Turno = 'TT', @ID_Sucursal = 3,
	@Estado = 1;
SELECT * FROM tienda.Empleado;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CLIENTE

-- 1. Probando AltaCliente: Inserción correcta.
SELECT * FROM tienda.Cliente;
EXEC tienda.AltaCliente @Nombre = 'Laura Garcia', @TipoCliente = 'Member', @Genero = 'F', @Estado = 1, @CUIT = '20-41141444-1';
SELECT * FROM tienda.Cliente;

-- 2. Probando AltaCliente: TipoCliente inválido (error de validación).
EXEC tienda.AltaCliente @Nombre = 'Laura Martinez', @TipoCliente = 'VIP', @Genero = 'F', @Estado = 1, @CUIT = '20-41141444-1';
SELECT * FROM tienda.Cliente;

EXEC tienda.BajaCliente @ID = 1;
SELECT * FROM tienda.Cliente;

-- 4. Probando ModificarCliente: Actualización correcta.
EXEC tienda.AltaCliente @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'M', @Estado = 1,@CUIT = '20-41141455-1';
SELECT * FROM tienda.Cliente;
EXEC tienda.ModificarCliente @ID = 1, @Nombre = 'Andres Gomez', @TipoCliente = 'Normal', @Genero = 'M', @Estado = 0;
SELECT * FROM tienda.Cliente;

-- 5. Probando ModificarCliente: Genero inválido (error de validación).
EXEC tienda.ModificarCliente @ID = 2, @Nombre = 'Andres', @TipoCliente = 'Normal', @Genero = 'F', @Estado = 1;
SELECT * FROM tienda.Cliente;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE CATEGORIA DE PRODUCTO

-- 1. Probando AltaCategoriaProducto: Inserción correcta.
SELECT * FROM catalogo.CategoriaProducto;
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Jardín', @Categoria = 'Muebles de Jardín';
SELECT * FROM catalogo.CategoriaProducto;

-- 2. Probando AltaCategoriaProducto: Categoría duplicada (error de validación).
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Cocina', @Categoria = 'Muebles de Jardín';
SELECT * FROM catalogo.CategoriaProducto;

-- 3. Probando BajaCategoriaProducto: Eliminación correcta.
EXEC catalogo.BajaCategoriaProducto @ID = 1;
SELECT * FROM catalogo.CategoriaProducto;

-- 4. Probando ModificarCategoriaProducto: Actualización correcta.
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Oficina', @Categoria = 'Muebles de Oficina';
SELECT * FROM catalogo.CategoriaProducto;
EXEC catalogo.ModificarCategoriaProducto @ID = 2, @LineaProducto = 'Línea Oficina', @Categoria = 'Sillas de Oficina';
SELECT * FROM catalogo.CategoriaProducto;

-- 5. Probando ModificarCategoriaProducto: Validación de categoría duplicada.
EXEC catalogo.ModificarCategoriaProducto @ID = 3, @LineaProducto = 'Línea Hogar', @Categoria = 'Sillas de Oficina';
SELECT * FROM catalogo.CategoriaProducto;

-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE PRODUCTO


-- 1. Probando AltaProducto: Inserción correcta.
Declare @date date
set @date = getdate()
SELECT * FROM catalogo.Producto;
EXEC catalogo.AltaProducto 
    @Nombre = 'Batidora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 3000.00, 
    @PrecioReferencia = 3000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;
SELECT * FROM catalogo.Producto;

-- 2. Probando AltaProducto: PrecioUnitario inválido (error de validación).
Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Tostadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = -1000.00,  -- Precio inválido
    @PrecioReferencia = 1000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;
SELECT * FROM catalogo.Producto;

-- 3. Probando BajaProducto: Eliminación correcta.
EXEC catalogo.BajaProducto @ID = 1; 
SELECT * FROM catalogo.Producto;

-- 4. Probando ModificarProducto: Actualización correcta.
Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Lavadora', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 8000.00, 
    @PrecioReferencia = 8000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;
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
    @Fecha = @date,
	@IVA = 0.21;
SELECT * FROM catalogo.Producto;

-- 5. Probando ModificarProducto: PrecioUnitario inválido (error de validación).
Declare @date date
set @date = getdate()
EXEC catalogo.ModificarProducto 
    @ID = 2, 
    @Nombre = 'Lavadora Blanca', 
    @ID_Categoria = 2, 
    @PrecioUnitario = 0.00,  -- Precio inválido
    @PrecioReferencia = 8500.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;
SELECT * FROM catalogo.Producto;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS DE MEDIOPAGO

-- 1. Probando AltaMedioPago: Inserción correcta.
SELECT * FROM ventas.MedioPago;
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Tarjeta de Crédito', 
    @Descripcion_ENG = 'Credit Card';

-- 2. Probando AltaMedioPago: Inserción duplicada (error de validación).
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Credit Card';  -- Ya existe
SELECT * FROM ventas.MedioPago;

-- 3. Probando BajaMedioPago: Eliminación correcta.
EXEC ventas.BajaMedioPago @ID = 1; 
SELECT * FROM ventas.MedioPago;

-- 4. Probando ModificarMedioPago: Actualización correcta.
PRINT 'Probando ModificarMedioPago - Actualización Correcta';
EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Transferencia Bancaria', 
    @Descripcion_ENG = 'Bank Transfer';
SELECT * FROM ventas.MedioPago;


EXEC ventas.ModificarMedioPago 
    @ID =2,  
    @Descripcion_ESP = 'Transferencia Electrónica', 
    @Descripcion_ENG = 'Electronic Transfer';
SELECT * FROM ventas.MedioPago;

-- 5. Probando ModificarMedioPago: Inserción duplicada (error de validación).
EXEC ventas.ModificarMedioPago 
    @ID = 3, 
    @Descripcion_ESP = 'Efectivo', 
    @Descripcion_ENG = 'Electronic Transfer';  
SELECT * FROM ventas.MedioPago;


-- CASOS DE PRUEBA PARA PROCEDIMIENTOS PARA GENERAR UNA VENTA

-- 1. Set de prueba para venta de varios productos.
EXEC informe.LimpiarTodasLasTablas;
EXEC tienda.AltaSucursal @Direccion = 'Calle Principal 456', @Ciudad = 'Ciudad Ejemplo', @Ciudad_anterior = NULL;
EXEC tienda.AltaEmpleado @Legajo = '000002', @Nombre = 'Ana', @Apellido = 'Lopez', @DNI = '87654321',
    @Mail_Empresa = 'ana.lopez@empresa.com', @CUIL = '27-87654321-9', @Cargo = 'Vendedor', @Turno = 'TT', @ID_Sucursal = 1, @Estado = 1;
EXEC tienda.AltaCliente @Nombre = 'Laura Garcia', @TipoCliente = 'Member', @Genero = 'F', @Estado = 1, @CUIT = '20-41141444-1';
EXEC catalogo.AltaCategoriaProducto @LineaProducto = 'Línea Jardín', @Categoria = 'Muebles de Jardín';

Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Lavadora', 
    @ID_Categoria = 1, 
    @PrecioUnitario = 8000.00, 
    @PrecioReferencia = 8000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;

Declare @date date
set @date = getdate()
EXEC catalogo.AltaProducto 
    @Nombre = 'Silla', 
    @ID_Categoria = 1, 
    @PrecioUnitario = 8000.00, 
    @PrecioReferencia = 8000.00, 
    @UnidadReferencia = 'Unidad', 
    @Fecha = @date,
	@IVA = 0.21;

EXEC ventas.AltaMedioPago 
    @Descripcion_ESP = 'Tarjeta de Crédito', 
    @Descripcion_ENG = 'Credit Card';

--Prueba crear venta
EXEC ventas.AltaVenta @ID_Cliente = 1, @ID_Sucursal = 1
SELECT * FROM ventas.Venta

--Prueba crear detalle venta
EXEC ventas.AltaDetalleVenta @ID_Venta=2, @ID_Producto= 2, @Cantidad=2
EXEC ventas.AltaDetalleVenta @ID_Venta=2, @ID_Producto= 3, @Cantidad=5
SELECT * FROM ventas.DetalleVenta

--Crear factura
EXEC ventas.AltaFactura @ID_Venta = 2 , @PuntoDeVenta = 0001,@Comprobante = '00000001'
SELECT * FROM ventas.Factura

--Crear detalle factura
EXEC ventas.AltaDetalleFactura @ID_Venta = 2, @ID_Factura = 1
SELECT * FROM ventas.DetalleFactura

--Crear pago
EXEC ventas.AltaPago @ID_Factura = 1, @ID_MedioPago = 1, @Monto = 30705.00
SELECT * FROM ventas.Pago
