USE Com2900G16
GO

-- Importaciones

DECLARE	@rutaInfoComplementaria NVARCHAR(256) = 'C:\Informacion_complementaria.xlsx'
DECLARE @rutaCatalogo NVARCHAR(256) = 'C:\catalogo.csv'
DECLARE @rutaAccesoriosElectronicos NVARCHAR(256) = 'C:\Electronic accessories.xlsx'
DECLARE @rutaProductosImportados NVARCHAR(256) = 'C:\Productos_importados.xlsx'
DECLARE @rutaVentas NVARCHAR(256) = 'C:\Ventas_registradas.csv'

--Importacion Sucursales
--EXEC tienda.ImportarSucursales @rutaInfoComplementaria
--EXEC tienda.ImportarEmpleados @rutaInfoComplementaria
--Importacion Catalogo
--EXEC catalogo.ImportarCategoriaProducto @rutaInfoComplementaria
--EXEC catalogo.importarCatalogoCsv @rutaCatalogo
--EXEC catalogo.ImportarDesdeExcel @rutaProductosImportados
--EXEC catalogo.ImportarDesdeExcelElectronicos @rutaAccesoriosElectronicos
--Importacion Ventas
--EXEC ventas.ImportarMediosDePago @rutaInfoComplementaria
--EXEC ventas.importarVentasCsv @rutaVentas


