USE Com2900G16
GO

-- Importaciones

DECLARE	@rutaInfoComplementaria NVARCHAR(256) = 'C:\Informacion_complementaria.xlsx'
DECLARE @rutaCatalogo NVARCHAR(256) = 'C:\catalogo.csv'
DECLARE @rutaAccesoriosElectronicos NVARCHAR(256) = 'C:\Electronic accessories.xlsx'
DECLARE @rutaProductosImportados NVARCHAR(256) = 'C:\Productos_importados.xlsx'
DECLARE @rutaVentas NVARCHAR(256) = 'C:\Ventas_registradas.csv'

--Importacion Sucursales
--SELECT * FROM tienda.Sucursal
--EXEC tienda.ImportarSucursales @rutaInfoComplementaria
--SELECT * FROM tienda.Sucursal

--SELECT * FROM tienda.Empleado
--EXEC tienda.ImportarEmpleados @rutaInfoComplementaria
--SELECT * FROM tienda.Empleado


--SELECT * FROM catalogo.CategoriaProducto
--EXEC catalogo.ImportarCategoriaProducto @rutaInfoComplementaria
--SELECT * FROM catalogo.CategoriaProducto

--SELECT * FROM catalogo.Producto
--EXEC catalogo.importarCatalogoCsv @rutaCatalogo
--SELECT * FROM catalogo.Producto

--SELECT * FROM catalogo.Producto
--EXEC catalogo.ImportarDesdeExcel @rutaProductosImportados
--SELECT * FROM catalogo.Producto

--SELECT * FROM catalogo.Producto
--EXEC catalogo.ImportarDesdeExcelElectronicos @rutaAccesoriosElectronicos
--SELECT * FROM catalogo.Producto

--SELECT * FROM ventas.MedioPago
--EXEC ventas.ImportarMediosDePago @rutaInfoComplementaria
--SELECT * FROM ventas.MedioPago

--SELECT * FROM ventas.Factura
--SELECT * FROM ventas.DetalleFactura
--EXEC ventas.importarVentasCsv @rutaVentas
--SELECT * FROM ventas.Factura
--SELECT * FROM ventas.DetalleFactura
