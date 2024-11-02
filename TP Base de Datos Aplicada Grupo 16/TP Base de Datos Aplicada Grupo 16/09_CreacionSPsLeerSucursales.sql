USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE tienda.ImportarSucursales
    @filePath NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Configurar opciones avanzadas
        EXEC sp_configure 'show advanced options', 1;
        RECONFIGURE;
        EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
        RECONFIGURE;

        IF OBJECT_ID('tempdb..#tmpSucursal') IS NOT NULL
            DROP TABLE #tmpSucursal;

        CREATE TABLE #tmpSucursal (
            Ciudad varchar(50),
            Reemplazo varchar(50),
            Direccion varchar(100),
            Horario varchar(50),
            Telefono varchar(20)
        );

        -- Construir la consulta OPENROWSET para importar desde Excel
        DECLARE @sql NVARCHAR(MAX) =
        N'INSERT INTO #tmpSucursal (Ciudad, Reemplazo, Direccion, Horario, Telefono)
         SELECT * FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
            ''SELECT * FROM [sucursal$]''
        )';

        EXEC sp_executesql @sql;

        INSERT INTO tienda.Sucursal (Direccion, Ciudad)
		(SELECT Direccion, Reemplazo FROM #tmpSucursal tmp WHERE NOT EXISTS 
		(SELECT 1 FROM tienda.Sucursal s WHERE tmp.Reemplazo = s.Ciudad collate Modern_Spanish_CI_AS AND tmp.Direccion = s.Direccion COLLATE Modern_Spanish_CI_AS)) 

    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    end catch

		DROP TABLE IF EXISTS #tmpSucursal;

end
SET NOCOUNT OFF