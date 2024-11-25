USE Com2900G16;
GO

-- Limpieza previa para evitar conflictos
EXEC informe.LimpiarTodasLasTablas;

-- Insertar datos en la tabla Sucursal
INSERT INTO tienda.Sucursal (Direccion, Ciudad) 
VALUES 
('Sucursal Centro', 'Ciudad A'),
('Sucursal Norte', 'Ciudad B'),
('Sucursal Sur', 'Ciudad C');
SELECT * FROM  tienda.Sucursal

-- Insertar datos en la tabla Empleado
INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, MailEmpresa, CUIL, Cargo, Turno, ID_Sucursal) 
VALUES 
('000001', 'Juan', 'Perez', '12345678', 'juan.perez@empresa.com', '20-12345678-9', 'Cajero', 'M', 1),
('000002', 'Ana', 'Garcia', '87654321', 'ana.garcia@empresa.com', '27-87654321-0', 'Supervisor', 'T', 2),
('000003', 'Luis', 'Lopez', '11223344', 'luis.lopez@empresa.com', '23-11223344-5', 'Gerente', 'N', 3);
SELECT * FROM  tienda.Empleado

-- Insertar datos en la tabla Cliente
INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, CUIT)
VALUES 
('Maria Lopez', 'Normal', 'F', '20-98765432-1'),
('Carlos Diaz', 'Member', 'M', '20-87654321-2');
SELECT * FROM  tienda.Cliente

-- Insertar datos en la tabla CategoriaProducto
INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
VALUES 
('Línea Blanca', 'Electrodomésticos'),
('Hogar', 'Muebles');
SELECT * FROM  catalogo.CategoriaProducto

-- Insertar datos en la tabla Producto
INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, Fecha, IVA)
VALUES 
('Heladera', 0, 45000.00, '2024-01-01', 0.21),
('Microondas', 0, 15000.00, '2024-01-02', 0.21),
('Silla', 1, 1200.00, '2024-01-03', 0.21);

-- Insertar datos en la tabla MedioPago
INSERT INTO ventas.MedioPago (Descripcion_ESP, Descripcion_ENG)
VALUES 
('Efectivo', 'Cash'),
('Tarjeta de Crédito', 'Credit Card'),
('Tarjeta de Débito', 'Debit Card');

-- Insertar datos en la tabla Venta
INSERT INTO ventas.Venta (Fecha, ID_Cliente, Total, Estado, ID_Sucursal)
VALUES 
('2024-11-01', 0, 47000.00, 'Pagada', 1),
('2024-11-02', 1, 30000.00, 'Pagada', 2),
('2024-11-03', 0, 1200.00, 'No pagada', 3);

-- Insertar datos en la tabla DetalleVenta
INSERT INTO ventas.DetalleVenta (ID_Venta, ID_Producto, Cantidad, Precio_Unitario, Subtotal)
VALUES 
(1, 1, 1, 45000.00, 45000.00),
(1, 2, 1, 15000.00, 15000.00),
(2, 3, 25, 1200.00, 30000.00);

-- Insertar datos en la tabla Factura
INSERT INTO ventas.Factura (Estado, FechaHora, Comprobante, PuntoDeVenta, SubTotal, IvaTotal, Total, ID_Venta)
VALUES 
('Pagada', '2024-11-01 10:00:00', 'A001', '00001', 47000.00, 9870.00, 56870.00, 1),
('Pagada', '2024-11-02 15:00:00', 'A002', '00002', 30000.00, 6300.00, 36300.00, 2),
('No pagada', '2024-11-03 18:00:00', 'A003', '00003', 1200.00, 252.00, 1452.00, 3);

-- Insertar datos en la tabla DetalleFactura
INSERT INTO ventas.DetalleFactura (ID_Factura, ID_Producto, Cantidad, PrecioUnitario, IVA, Subtotal)
VALUES 
(1, 1, 1, 45000.00, 9450.00, 54450.00),
(1, 2, 1, 15000.00, 3150.00, 18150.00),
(2, 3, 25, 1200.00, 2520.00, 31500.00);

-- Insertar datos en la tabla Pago
INSERT INTO ventas.Pago (ID_Factura, ID_MedioPago, Monto)
VALUES 
(1, 1, 56870.00),
(2, 2, 36300.00);

-- Insertar datos en la tabla NotaCredito
INSERT INTO ventas.NotaCredito (ID_Factura, ID_Cliente, ID_Producto, FechaEmision, Motivo, Comprobante)
VALUES 
(1, 1, 2, '2024-11-01', 'Producto defectuoso', 'NC001');



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
