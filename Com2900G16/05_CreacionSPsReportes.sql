USE Com2900G16;
GO

-- Reporte mensual: Total facturado por días de la semana (considerando notas de crédito)
CREATE OR ALTER PROCEDURE informe.ObtenerReporteMensualPorDias
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DATENAME(WEEKDAY, f.FechaHora) AS DiaSemana,
        SUM(f.Total - ISNULL(nc.TotalCredito, 0)) AS TotalFacturado
    FROM ventas.Factura f
    LEFT JOIN (
        SELECT nc.ID_Factura, SUM(ncd.Subtotal) AS TotalCredito
        FROM ventas.NotaCredito nc
        JOIN ventas.DetalleFactura ncd ON nc.ID_Factura = ncd.ID_Factura
        WHERE ncd.Estado = 1 -- Nota válida
        GROUP BY nc.ID_Factura
    ) nc ON f.ID = nc.ID_Factura
    WHERE MONTH(f.FechaHora) = @Mes AND YEAR(f.FechaHora) = @Anio AND f.Estado = 'Pagada'
    GROUP BY DATENAME(WEEKDAY, f.FechaHora)
    FOR XML PATH('Dia'), ROOT('ReporteMensualPorDias');
END;


-- Reporte trimestral: Total facturado por turnos de trabajo por mes (considerando notas de crédito)
CREATE OR ALTER PROCEDURE informe.ObtenerReporteTrimestralPorTurnos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DATEPART(MONTH, v.Fecha) AS Mes,
        e.Turno,
        SUM(f.Total - ISNULL(nc.TotalCredito, 0)) AS TotalFacturado
    FROM ventas.Venta v
    JOIN ventas.Factura f ON v.ID = f.ID_Venta
    JOIN tienda.Empleado e ON v. = e.ID
    LEFT JOIN (
        SELECT nc.ID_Factura, SUM(ncd.Subtotal) AS TotalCredito
        FROM ventas.NotaCredito nc
        JOIN ventas.DetalleFactura ncd ON nc.ID_Factura = ncd.ID_Factura
        WHERE nc.Estado = 1
        GROUP BY nc.ID_Factura
    ) nc ON f.ID = nc.ID_Factura
    WHERE f.Estado = 'Pagada'
    GROUP BY DATEPART(MONTH, v.Fecha), e.Turno
    FOR XML PATH('Mes'), ROOT('ReporteTrimestralPorTurnos');
END;
GO



-- Reporte por rango de fechas: Cantidad de productos vendidos (considerando notas de crédito)
CREATE  OR ALTER PROCEDURE informe.ObtenerProductosVendidosPorRangoFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.Nombre AS Producto,
        SUM(dv.Cantidad - ISNULL(nc.Cantidad, 0)) AS CantidadVendida
    FROM ventas.DetalleVenta dv
    JOIN catalogo.Producto p ON dv.ID_Producto = p.ID
    JOIN ventas.Venta v ON dv.ID_Venta = v.ID
    JOIN ventas.Factura f ON f.ID_Venta = v.ID
    LEFT JOIN (
        SELECT ncd.ID_Producto, ncd.ID_Venta, SUM(ncd.Cantidad) AS Cantidad
        FROM ventas.NotaCredito nc
        JOIN ventas.DetalleFactura ncd ON nc.ID_Factura = ncd.ID_Factura
        WHERE nc.Estado = 1
        GROUP BY ncd.ID_Producto, ncd.ID_Venta
    ) nc ON dv.ID_Producto = nc.ID_Producto AND dv.ID_Venta = nc.ID_Venta
    WHERE v.Fecha BETWEEN @FechaInicio AND @FechaFin AND f.Estado = 'Pagada'
    GROUP BY p.Nombre
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('ReporteProductosVendidos');
END;
GO


-- Reporte por rango de fechas: Cantidad de productos vendidos por sucursal (considerando notas de crédito)
CREATE OR ALTER PROCEDURE informe.ObtenerProductosVendidosPorRangoFechasSucursal
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.Direccion AS Sucursal,
        p.Nombre AS Producto,
        SUM(dv.Cantidad - ISNULL(nc.Cantidad, 0)) AS CantidadVendida
    FROM ventas.DetalleVenta dv
    JOIN catalogo.Producto p ON dv.ID_Producto = p.ID
    JOIN ventas.Venta v ON dv.ID_Venta = v.ID
    JOIN tienda.Sucursal s ON v.ID_Sucursal = s.ID
    JOIN ventas.Factura f ON f.ID_Venta = v.ID
    LEFT JOIN (
        SELECT ID_Producto, ID_Venta, SUM(Cantidad) AS Cantidad
        FROM ventas.NotaCredito
        WHERE Estado = 1
        GROUP BY ID_Producto, ID_Venta
    ) nc ON dv.ID_Producto = nc.ID_Producto AND dv.ID_Venta = nc.ID_Venta
    WHERE v.Fecha BETWEEN @FechaInicio AND @FechaFin AND f.Estado = 'Pagada'
    GROUP BY s.Direccion, p.Nombre
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Sucursal'), ROOT('ReporteProductosVendidosPorSucursal');
END;
GO

-- Reporte mensual: Top 5 productos más vendidos por semana (considerando notas de crédito)
CREATE OR ALTER PROCEDURE informe.ObtenerTop5ProductosVendidosPorMes
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 5
        DATENAME(WEEK, v.Fecha) AS Semana,
        p.Nombre AS Producto,
        SUM(dv.Cantidad - ISNULL(nc.Cantidad, 0)) AS CantidadVendida
    FROM ventas.DetalleVenta dv
    JOIN catalogo.Producto p ON dv.ID_Producto = p.ID
    JOIN ventas.Venta v ON dv.ID_Venta = v.ID
    JOIN ventas.Factura f ON f.ID_Venta = v.ID
    LEFT JOIN (
        SELECT ID_Producto, ID_Venta, SUM(Cantidad) AS Cantidad
        FROM ventas.NotaCredito
        WHERE Estado = 1
        GROUP BY ID_Producto, ID_Venta
    ) nc ON dv.ID_Producto = nc.ID_Producto AND dv.ID_Venta = nc.ID_Venta
    WHERE MONTH(v.Fecha) = @Mes AND f.Estado = 'Pagada'
    GROUP BY DATENAME(WEEK, v.Fecha), p.Nombre
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('ReporteTop5ProductosVendidos');
END;
GO

-- Reporte mensual: Top 5 productos menos vendidos (considerando notas de crédito)
CREATE OR ALTER PROCEDURE informe.ObtenerTop5ProductosMenosVendidosPorMes
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 5
        p.Nombre AS Producto,
        SUM(dv.Cantidad - ISNULL(nc.Cantidad, 0)) AS CantidadVendida
    FROM ventas.DetalleVenta dv
    JOIN catalogo.Producto p ON dv.ID_Producto = p.ID
    JOIN ventas.Venta v ON dv.ID_Venta = v.ID
    JOIN ventas.Factura f ON f.ID_Venta = v.ID
    LEFT JOIN (
        SELECT ID_Producto, ID_Venta, SUM(Cantidad) AS Cantidad
        FROM ventas.NotaCredito
        WHERE Estado = 1
        GROUP BY ID_Producto, ID_Venta
    ) nc ON dv.ID_Producto = nc.ID_Producto AND dv.ID_Venta = nc.ID_Venta
    WHERE MONTH(v.Fecha) = @Mes AND f.Estado = 'Pagada'
    GROUP BY p.Nombre
    ORDER BY CantidadVendida ASC
    FOR XML PATH('Producto'), ROOT('ReporteTop5ProductosMenosVendidos');
END;
GO

-- Reporte acumulado de ventas por fecha y sucursal (considerando notas de crédito)
CREATE PROCEDURE informe.ObtenerTotalAcumuladoVentasPorFechaYSucursal
    @Fecha DATE,
    @ID_Sucursal INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        v.ID AS VentaID,
        f.Total - ISNULL(nc.TotalCredito, 0) AS TotalVenta,
        dv.ID_Producto AS ProductoID,
        dv.Cantidad - ISNULL(nc.Cantidad, 0) AS Cantidad,
        dv.Precio_Unitario,
        ((dv.Cantidad - ISNULL(nc.Cantidad, 0)) * dv.Precio_Unitario) AS Subtotal
    FROM ventas.Venta v
    JOIN ventas.Factura f ON v.ID = f.ID_Venta
    JOIN ventas.DetalleVenta dv ON v.ID = dv.ID_Venta
    LEFT JOIN (
        SELECT ID_Factura, ID_Producto, SUM(Cantidad) AS Cantidad, SUM(Detalle.Subtotal) AS TotalCredito
        FROM ventas.NotaCredito nc
        LEFT JOIN ventas.DetalleFactura Detalle ON nc.ID_Factura = Detalle.ID_Factura
        WHERE nc.Estado = 1
        GROUP BY ID_Factura, ID_Producto
    ) nc ON f.ID = nc.ID_Factura AND dv.ID_Producto = nc.ID_Producto
    WHERE v.Fecha = @Fecha AND v.ID_Sucursal = @ID_Sucursal AND f.Estado = 'Pagada'
    FOR XML PATH('Venta'), ROOT('ReporteAcumuladoVentas');
END;
GO


