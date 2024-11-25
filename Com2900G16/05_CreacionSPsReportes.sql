USE Com2900G16;
GO

-- 1. Reporte Mensual: Total facturado por días de la semana
CREATE OR ALTER PROCEDURE informe.ObtenerReporteMensualPorDias
    @Mes INT,
    @Anio INT
AS
BEGIN
    SELECT 
        DATENAME(WEEKDAY, V.Fecha) AS DiaSemana,
        SUM(F.Total - ISNULL(NC.TotalAjustado, 0)) AS TotalFacturado
    FROM ventas.Venta V
    INNER JOIN ventas.Factura F ON V.ID = F.ID_Venta
    LEFT JOIN (
        SELECT NC.ID_Factura, SUM(DF.Cantidad * DF.PrecioUnitario + DF.IVA) AS TotalAjustado
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY NC.ID_Factura
    ) NC ON F.ID = NC.ID_Factura
    WHERE MONTH(V.Fecha) = @Mes AND YEAR(V.Fecha) = @Anio
    GROUP BY DATENAME(WEEKDAY, V.Fecha)
    ORDER BY 
        CASE DATENAME(WEEKDAY, V.Fecha)
            WHEN 'Lunes' THEN 1
            WHEN 'Martes' THEN 2
            WHEN 'Miércoles' THEN 3
            WHEN 'Jueves' THEN 4
            WHEN 'Viernes' THEN 5
            WHEN 'Sábado' THEN 6
            WHEN 'Domingo' THEN 7
        END
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 2. Reporte Trimestral: Total facturado por turnos de trabajo por mes
CREATE OR ALTER PROCEDURE informe.ObtenerReporteTrimestralPorTurnos
    @Trimestre INT,
    @Anio INT
AS
BEGIN
    SELECT 
        MONTH(V.Fecha) AS Mes,
        E.Turno,
        SUM(F.Total - ISNULL(NC.TotalAjustado, 0)) AS TotalFacturado
    FROM ventas.Venta V
    INNER JOIN ventas.Factura F ON V.ID = F.ID_Venta
    INNER JOIN tienda.Empleado E ON V.ID_Cliente = E.ID
    LEFT JOIN (
        SELECT NC.ID_Factura, SUM(DF.Cantidad * DF.PrecioUnitario + DF.IVA) AS TotalAjustado
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY NC.ID_Factura
    ) NC ON F.ID = NC.ID_Factura
    WHERE (MONTH(V.Fecha) - 1) / 3 + 1 = @Trimestre AND YEAR(V.Fecha) = @Anio
    GROUP BY MONTH(V.Fecha), E.Turno
    ORDER BY Mes, E.Turno
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 3. Reporte por Rango de Fechas: Cantidad de productos vendidos
CREATE OR ALTER PROCEDURE informe.ObtenerProductosVendidosPorRangoFechas
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SELECT 
        P.Nombre AS Producto,
        SUM(DV.Cantidad - ISNULL(NC.CantidadAjustada, 0)) AS TotalVendido
    FROM ventas.DetalleVenta DV
    INNER JOIN catalogo.Producto P ON DV.ID_Producto = P.ID
    LEFT JOIN (
        SELECT DF.ID_Producto, SUM(DF.Cantidad) AS CantidadAjustada
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY DF.ID_Producto
    ) NC ON DV.ID_Producto = NC.ID_Producto
    WHERE DV.ID_Venta IN (
        SELECT ID FROM ventas.Venta WHERE Fecha BETWEEN @FechaInicio AND @FechaFin
    )
    GROUP BY P.Nombre
    ORDER BY TotalVendido DESC
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 4. Reporte por Rango de Fechas: Cantidad de productos vendidos por sucursal
CREATE OR ALTER PROCEDURE informe.ObtenerProductosVendidosPorRangoFechasSucursal
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SELECT 
        S.Direccion AS Sucursal,
        P.Nombre AS Producto,
        SUM(DV.Cantidad - ISNULL(NC.CantidadAjustada, 0)) AS TotalVendido
    FROM ventas.DetalleVenta DV
    INNER JOIN catalogo.Producto P ON DV.ID_Producto = P.ID
    INNER JOIN tienda.Sucursal S ON DV.ID_Venta = S.ID
    LEFT JOIN (
        SELECT DF.ID_Producto, SUM(DF.Cantidad) AS CantidadAjustada
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY DF.ID_Producto
    ) NC ON DV.ID_Producto = NC.ID_Producto
    WHERE DV.ID_Venta IN (
        SELECT ID FROM ventas.Venta WHERE Fecha BETWEEN @FechaInicio AND @FechaFin
    )
    GROUP BY S.Direccion, P.Nombre
    ORDER BY TotalVendido DESC
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 5. Top 5 Productos Más Vendidos en un Mes
CREATE OR ALTER PROCEDURE informe.ObtenerTop5ProductosVendidosPorMes
    @Mes INT,
    @Anio INT
AS
BEGIN
    SELECT 
        P.Nombre AS Producto,
        SUM(DV.Cantidad - ISNULL(NC.CantidadAjustada, 0)) AS TotalVendido
    FROM ventas.DetalleVenta DV
    INNER JOIN catalogo.Producto P ON DV.ID_Producto = P.ID
    INNER JOIN ventas.Venta V ON DV.ID_Venta = V.ID
    LEFT JOIN (
        SELECT DF.ID_Producto, SUM(DF.Cantidad) AS CantidadAjustada
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY DF.ID_Producto
    ) NC ON DV.ID_Producto = NC.ID_Producto
    WHERE MONTH(V.Fecha) = @Mes AND YEAR(V.Fecha) = @Anio
    GROUP BY P.Nombre
    ORDER BY TotalVendido DESC
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 6. Top 5 Productos Menos Vendidos en un Mes
CREATE OR ALTER PROCEDURE informe.ObtenerTop5ProductosMenosVendidosPorMes
    @Mes INT,
    @Anio INT
AS
BEGIN
    SELECT 
        P.Nombre AS Producto,
        SUM(DV.Cantidad - ISNULL(NC.CantidadAjustada, 0)) AS TotalVendido
    FROM ventas.DetalleVenta DV
    INNER JOIN catalogo.Producto P ON DV.ID_Producto = P.ID
    LEFT JOIN (
        SELECT DF.ID_Producto, SUM(DF.Cantidad) AS CantidadAjustada
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY DF.ID_Producto
    ) NC ON DV.ID_Producto = NC.ID_Producto
    WHERE MONTH(DV.ID_Venta) = @Mes AND YEAR(DV.ID_Venta) = @Anio
    GROUP BY P.Nombre
    ORDER BY TotalVendido ASC
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO

-- 7. Total Acumulado de Ventas para una Fecha y Sucursal
CREATE OR ALTER PROCEDURE informe.ObtenerTotalAcumuladoVentasPorFechaYSucursal
    @Fecha DATE,
    @SucursalID INT
AS
BEGIN
    SELECT 
        S.Direccion AS Sucursal,
        V.Fecha,
        SUM(F.Total - ISNULL(NC.TotalAjustado, 0)) AS TotalFacturado,
        STRING_AGG(P.Nombre + ': ' + CAST(DV.Cantidad AS VARCHAR), ', ') AS Detalle
    FROM ventas.Venta V
    INNER JOIN ventas.Factura F ON V.ID = F.ID_Venta
    INNER JOIN tienda.Sucursal S ON V.ID_Sucursal = S.ID
    INNER JOIN ventas.DetalleVenta DV ON V.ID = DV.ID_Venta
    INNER JOIN catalogo.Producto P ON DV.ID_Producto = P.ID
    LEFT JOIN (
        SELECT NC.ID_Factura, SUM(DF.Cantidad * DF.PrecioUnitario + DF.IVA) AS TotalAjustado
        FROM ventas.NotaCredito NC
        INNER JOIN ventas.DetalleFactura DF ON NC.ID_Factura = DF.ID_Factura
        GROUP BY NC.ID_Factura
    ) NC ON F.ID = NC.ID_Factura
    WHERE CAST(V.Fecha AS DATE) = @Fecha AND S.ID = @SucursalID
    GROUP BY S.Direccion, V.Fecha
    FOR XML PATH('Row'), ROOT('Reporte');
END;
GO
