USE Com2900G16;
GO
/*
--Alumnos
<Avella Mateo, 45318319
<Rius Conde Lucio, 41779534
<

GRUPO 16
ENTREGA: 05/11/24

Se requiere que importe toda la información antes mencionada a la base de datos:
	• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
	archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
	novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
	• Considere este comportamiento al generar el código. Debe admitir la importación de
	novedades periódicamente.
	• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
	realicen tareas por fuera de un SP.
	• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
	realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
	estructura requerida.
	• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
	cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
	en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
	interpretarlo como JSON o CSV). 

*/
-- 1. Reporte Mensual: Total facturado por días de la semana
CREATE OR ALTER PROCEDURE informe.ObtenerReporteMensualPorDias
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


-- 2. Reporte Trimestral: Total facturado por turnos de trabajo por mes
GO
CREATE OR ALTER PROCEDURE informe.ObtenerReporteTrimestralPorTurnos
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

-- 3. Reporte por Rango de Fechas: Cantidad de productos vendidos
GO
CREATE OR ALTER PROCEDURE informe.ObtenerProductosVendidosPorRangoFechas
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

-- 4. Reporte por Rango de Fechas: Cantidad de productos vendidos por sucursal
GO
CREATE OR ALTER  PROCEDURE informe.ObtenerProductosVendidosPorRangoFechasSucursal
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

-- 5. Top 5 Productos Más Vendidos en un Mes
GO
CREATE OR ALTER  PROCEDURE informe.ObtenerTop5ProductosVendidosPorMes
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

-- 6. Top 5 Productos Menos Vendidos en un Mes
GO
CREATE OR ALTER  PROCEDURE informe.ObtenerTop5ProductosMenosVendidosPorMes
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

-- 7. Total Acumulado de Ventas para una Fecha y Sucursal
GO
CREATE OR ALTER PROCEDURE informe.ObtenerTotalAcumuladoVentasPorFechaYSucursal
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
