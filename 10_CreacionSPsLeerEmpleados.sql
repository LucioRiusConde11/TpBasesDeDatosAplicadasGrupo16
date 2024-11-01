USE [GRUPO_16]
GO

SET NOCOUNT ON
GO
CREATE OR ALTER PROCEDURE tienda.ImportarEmpleados
    @filePath NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Configurar opciones avanzadas
        EXEC sp_configure 'show advanced options', 1;
        RECONFIGURE;
        EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
        RECONFIGURE;

        IF OBJECT_ID('tempdb..#tmpEmpleado') IS NOT NULL
            DROP TABLE #tmpEmpleado;

        CREATE TABLE #tmpEmpleado (
			Legajo VARCHAR(10),
			Nombre VARCHAR(100),
			Apellido VARCHAR(100),
			DNI VARCHAR(8),
			dni_float float,
			Direccion VARCHAR(100),
			mail_personal VARCHAR(100),
			mail_empresa VARCHAR(100),
			CUIL VARCHAR(14),
			Cargo VARCHAR(50),
			Ciudad_Sucursal VARCHAR(50),
			Turno VARCHAR(25)
        );

        -- Construir la consulta OPENROWSET para importar desde Excel
        DECLARE @sql NVARCHAR(MAX) =
        N'INSERT INTO #tmpEmpleado (Legajo, Nombre, Apellido, dni_float, Direccion, mail_personal, mail_empresa, CUIL, Cargo, Ciudad_Sucursal, Turno)
         SELECT * FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
            ''SELECT * FROM [Empleados$]''
        )';

        EXEC sp_executesql @sql;
		
		UPDATE #tmpEmpleado
		SET DNI = cast((convert(int, dni_float)) as varchar(8))

		INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal)
		(SELECT tmp.Legajo, tmp.Nombre, tmp.Apellido,
		DNI, tmp.mail_empresa, CONCAT('23','-',tmp.DNI,'-','4'),
		tmp.Cargo, tmp.Turno, 
		(SELECT ID FROM tienda.Sucursal WHERE Ciudad = Ciudad_Sucursal COLLATE Modern_Spanish_CI_AS)
		FROM #tmpEmpleado tmp
		WHERE tmp.Legajo IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tienda.Empleado e WHERE tmp.Legajo = e.legajo COLLATE Modern_Spanish_CI_AS OR tmp.DNI = e.DNI COLLATE Modern_Spanish_CI_AS))
		
    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    end catch

		DROP TABLE IF EXISTS #tmpEmpleado;

end
SET NOCOUNT OFF