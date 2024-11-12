USE Com2900G16;
GO

-- Limpieza previa para evitar conflictos
EXEC informe.LimpiarTodasLasTablas;

-- Inserción de datos en catalogo.CategoriaProducto
INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
VALUES 
    ('Alimentos', 'Galletas'),
    ('Alimentos', 'Cereales'),
    ('Bebidas', 'Jugos'),
    ('Bebidas', 'Gaseosas');

-- Inserción de datos en tienda.Sucursal
INSERT INTO tienda.Sucursal (Direccion, Ciudad, Ciudad_anterior)
VALUES 
    ('Avenida Siempre Viva 123', 'Springfield', NULL),
    ('Calle Falsa 456', 'Shelbyville', NULL);

-- Inserción de datos en tienda.Cliente
INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Estado)
VALUES 
    ('Homer Simpson', 'Normal', 'M', 1),
    ('Marge Simpson', 'Member', 'F', 1),
    ('Bart Simpson', 'Normal', 'M', 1);

-- Inserción de datos en tienda.Empleado
INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
VALUES 
    ('000001', 'Lenny', 'Leonard', '12345678', 'lenny@tienda.com', '20-12345678-9', 'Cajero', 'M', 1, 1),
    ('000002', 'Carl', 'Carlson', '87654321', 'carl@tienda.com', '20-87654321-7', 'Cajero', 'T', 2, 1);

-- Inserción de datos en catalogo.Producto
INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
VALUES 
    ('Galletas de Chocolate', 1, 50.00, 45.00, '100g', '2024-01-01'),
    ('Cereal de Avena', 2, 80.00, 75.00, '200g', '2024-01-02'),
    ('Jugo de Naranja', 3, 30.00, 28.00, '500ml', '2024-01-03'),
    ('Gaseosa Cola', 4, 60.00, 58.00, '1L', '2024-01-04');

-- Inserción de datos en ventas.MedioPago
INSERT INTO ventas.MedioPago (Descripcion_ESP, Descripcion_ENG)
VALUES 
    ('Efectivo', 'Cash'),
    ('Tarjeta de Crédito', 'Credit Card'),
    ('Tarjeta de Débito', 'Debit Card');

-- Inserción de datos en ventas.Factura
INSERT INTO ventas.Factura (FechaHora, Estado, ID_Cliente, ID_Empleado, ID_Sucursal, ID_MedioPago, PuntoDeVenta, Comprobante, id_factura_importado)
VALUES 
    ('2024-01-10 10:00:00', 'Pagada', 1, 1, 1, 1, '00001', 12345, NULL),
    ('2024-01-11 15:30:00', 'Pagada', 2, 2, 2, 2, '00002', 67890, NULL);

-- Inserción de datos en ventas.DetalleFactura
INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario, IdentificadorPago)
VALUES 
    (1, 1, 2, 50.00, 'IDPago001'), 
    (1, 2, 1, 80.00, 'IDPago002'),
    (2, 3, 3, 30.00, 'IDPago003'), 
    (2, 4, 1, 60.00, 'IDPago004');



--- 1. Llamado para obtener el reporte mensual de total facturado por días de la semana
EXEC informe.ObtenerReporteMensualPorDias @Mes = 1, @Anio = 2024;
-- Esperado: 
-- <Reporte>
--   <Row>
--     <DiaSemana>Wednesday</DiaSemana>
--     <TotalFacturado>180.00</TotalFacturado>
--   </Row>
--   <Row>
--     <DiaSemana>Thursday</DiaSemana>
--     <TotalFacturado>150.00</TotalFacturado>
--   </Row>
-- </Reporte>

-- 2. Llamado para obtener el reporte trimestral de total facturado por turnos de trabajo por mes
EXEC informe.ObtenerReporteTrimestralPorTurnos @Trimestre = 1;
-- Esperado:
-- <Reporte>
--   <Row>
--     <Mes>1</Mes>
--     <Turno>M</Turno>
--     <TotalFacturado>180.00</TotalFacturado>
--   </Row>
--   <Row>
--     <Mes>1</Mes>
--     <Turno>T</Turno>
--     <TotalFacturado>150.00</TotalFacturado>
--   </Row>
-- </Reporte>

-- 3. Llamado para obtener la cantidad de productos vendidos en un rango de fechas
EXEC informe.ObtenerProductosVendidosPorRangoFechas @FechaInicio = '2024-01-01', @FechaFin = '2024-01-31';
-- Esperado:
-- <Reporte>
--   <Row>
--     <Nombre>Jugo de Naranja</Nombre>
--     <CantidadVendida>3</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Galletas de Chocolate</Nombre>
--     <CantidadVendida>2</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Gaseosa Cola</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Cereal de Avena</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
-- </Reporte>

-- 4. Llamado para obtener la cantidad de productos vendidos por sucursal en un rango de fechas
EXEC informe.ObtenerProductosVendidosPorRangoFechasSucursal @FechaInicio = '2024-01-01', @FechaFin = '2024-01-31';
-- Esperado:
-- <Reporte>
--   <Row>
--     <Direccion>Avenida Siempre Viva 123</Direccion>
--     <Nombre>Galletas de Chocolate</Nombre>
--     <CantidadVendida>2</CantidadVendida>
--   </Row>
--   <Row>
--     <Direccion>Avenida Siempre Viva 123</Direccion>
--     <Nombre>Cereal de Avena</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
--   <Row>
--     <Direccion>Calle Falsa 456</Direccion>
--     <Nombre>Jugo de Naranja</Nombre>
--     <CantidadVendida>3</CantidadVendida>
--   </Row>
--   <Row>
--     <Direccion>Calle Falsa 456</Direccion>
--     <Nombre>Gaseosa Cola</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
-- </Reporte>

-- 5. Llamado para obtener el top 5 de productos más vendidos en un mes
EXEC informe.ObtenerTop5ProductosVendidosPorMes @Mes = 1, @Anio = 2024;
-- Esperado:
-- <Reporte>
--   <Row>
--     <Nombre>Jugo de Naranja</Nombre>
--     <CantidadVendida>3</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Galletas de Chocolate</Nombre>
--     <CantidadVendida>2</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Cereal de Avena</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Gaseosa Cola</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
-- </Reporte>

-- 6. Llamado para obtener el top 5 de productos menos vendidos en un mes
EXEC informe.ObtenerTop5ProductosMenosVendidosPorMes @Mes = 1, @Anio = 2024;
-- Esperado:
-- <Reporte>
--   <Row>
--     <Nombre>Cereal de Avena</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Gaseosa Cola</Nombre>
--     <CantidadVendida>1</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Galletas de Chocolate</Nombre>
--     <CantidadVendida>2</CantidadVendida>
--   </Row>
--   <Row>
--     <Nombre>Jugo de Naranja</Nombre>
--     <CantidadVendida>3</CantidadVendida>
--   </Row>
-- </Reporte>

-- 7. Llamado para obtener el total acumulado de ventas para una fecha y sucursal
EXEC informe.ObtenerTotalAcumuladoVentasPorFechaYSucursal @Fecha = '2024-01-10', @SucursalID = 1;
-- Esperado:
-- <Reporte>
--   <Row>
--     <TotalAcumulado>180.00</TotalAcumulado>
--     <FechaHora>2024-01-10 10:00:00</FechaHora>
--   </Row>
-- </Reporte>
