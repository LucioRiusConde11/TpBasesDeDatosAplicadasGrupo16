USE Com2900G16;
GO
-- 1. Reporte Mensual: Total facturado por días de la semana
CREATE OR ALTER PROCEDURE ObtenerReporteMensualPorDias
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DATENAME(WEEKDAY, FechaHora) AS DiaSemana,
        SUM(PrecioUnitario * Cantidad) AS TotalFacturado
    FROM
        ventas.Factura f
    JOIN
        ventas.DetalleFactura df ON f.ID = df.ID_Factura
    WHERE
        MONTH(f.FechaHora) = @Mes AND YEAR(f.FechaHora) = @Anio
    GROUP BY
        DATENAME(WEEKDAY, FechaHora)
    ORDER BY
        CASE DATENAME(WEEKDAY, FechaHora)
            WHEN 'Sunday' THEN 1
            WHEN 'Monday' THEN 2
            WHEN 'Tuesday' THEN 3
            WHEN 'Wednesday' THEN 4
            WHEN 'Thursday' THEN 5
            WHEN 'Friday' THEN 6
            WHEN 'Saturday' THEN 7
        END
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 2. Reporte Trimestral: Total facturado por turnos de trabajo por mes
CREATE OR ALTER  PROCEDURE ObtenerReporteTrimestralPorTurnos
    @Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MONTH(FechaHora) AS Mes,
        Turno,
        SUM(PrecioUnitario * Cantidad) AS TotalFacturado
    FROM
        ventas.Factura f
    JOIN
        ventas.DetalleFactura df ON f.ID = df.ID_Factura
    JOIN
        tienda.Empleado e ON f.ID_Empleado = e.ID
    WHERE
        MONTH(f.FechaHora) BETWEEN (3 * @Trimestre - 2) AND (3 * @Trimestre)
    GROUP BY
        MONTH(FechaHora), Turno
    ORDER BY
        Mes
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 3. Reporte por Rango de Fechas: Cantidad de productos vendidos
CREATE OR ALTER  PROCEDURE ObtenerProductosVendidosPorRangoFechas
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.Nombre,
        SUM(df.Cantidad) AS CantidadVendida
    FROM
        ventas.DetalleFactura df
    JOIN
        ventas.Factura f ON df.ID_Factura = f.ID
    JOIN
        catalogo.Producto p ON df.ID_Producto = p.ID
    WHERE
        f.FechaHora BETWEEN @FechaInicio AND @FechaFin
    GROUP BY
        p.Nombre
    ORDER BY
        CantidadVendida DESC
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 4. Reporte por Rango de Fechas: Cantidad de productos vendidos por sucursal
CREATE OR ALTER  PROCEDURE ObtenerProductosVendidosPorRangoFechasSucursal
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.Direccion,
        p.Nombre,
        SUM(df.Cantidad) AS CantidadVendida
    FROM
        ventas.DetalleFactura df
    JOIN
        ventas.Factura f ON df.ID_Factura = f.ID
    JOIN
        catalogo.Producto p ON df.ID_Producto = p.ID
    JOIN
        tienda.Sucursal s ON f.ID_Sucursal = s.ID
    WHERE
        f.FechaHora BETWEEN @FechaInicio AND @FechaFin
    GROUP BY
        s.Direccion, p.Nombre
    ORDER BY
        CantidadVendida DESC
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 5. Top 5 Productos Más Vendidos en un Mes
CREATE OR ALTER  PROCEDURE ObtenerTop5ProductosVendidosPorMes
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 5
        p.Nombre,
        SUM(df.Cantidad) AS CantidadVendida
    FROM
        ventas.DetalleFactura df
    JOIN
        ventas.Factura f ON df.ID_Factura = f.ID
    JOIN
        catalogo.Producto p ON df.ID_Producto = p.ID
    WHERE
        MONTH(f.FechaHora) = @Mes AND YEAR(f.FechaHora) = @Anio
    GROUP BY
        p.Nombre
    ORDER BY
        CantidadVendida DESC
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 6. Top 5 Productos Menos Vendidos en un Mes
CREATE OR ALTER  PROCEDURE ObtenerTop5ProductosMenosVendidosPorMes
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 5
        p.Nombre,
        SUM(df.Cantidad) AS CantidadVendida
    FROM
        ventas.DetalleFactura df
    JOIN
        ventas.Factura f ON df.ID_Factura = f.ID
    JOIN
        catalogo.Producto p ON df.ID_Producto = p.ID
    WHERE
        MONTH(f.FechaHora) = @Mes AND YEAR(f.FechaHora) = @Anio
    GROUP BY
        p.Nombre
    ORDER BY
        CantidadVendida ASC
    FOR XML PATH('Row'), ROOT('Reporte');
END;

GO;
-- 7. Total Acumulado de Ventas para una Fecha y Sucursal
CREATE OR ALTER PROCEDURE ObtenerTotalAcumuladoVentasPorFechaYSucursal
    @Fecha DATE,
    @SucursalID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SUM(PrecioUnitario * Cantidad) AS TotalAcumulado,
        f.FechaHora
    FROM
        ventas.DetalleFactura df
    JOIN
        ventas.Factura f ON df.ID_Factura = f.ID
    WHERE
        CAST(f.FechaHora AS DATE) = @Fecha AND f.ID_Sucursal = @SucursalID
    GROUP BY
        f.FechaHora
    FOR XML PATH('Row'), ROOT('Reporte');
END;
