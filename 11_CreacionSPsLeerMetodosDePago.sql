USE [GRUPO_16]
GO

SET NOCOUNT ON
GO
CREATE OR ALTER PROCEDURE ventas.ImportarMediosDePago
    @filePath NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Configurar opciones avanzadas
        EXEC sp_configure 'show advanced options', 1;
        RECONFIGURE;
        EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
        RECONFIGURE;

        IF OBJECT_ID('tempdb..#tmpMedioDePago') IS NOT NULL
            DROP TABLE #tmpMedioDePago;

        CREATE TABLE #tmpMedioDePago (
			AUX CHAR(1),
			ENG VARCHAR(50),
			ESP VARCHAR(50)
        );

        -- Construir la consulta OPENROWSET para importar desde Excel
        DECLARE @sql NVARCHAR(MAX) =
        N'INSERT INTO #tmpMedioDePago (AUX, ENG, ESP)
         SELECT * FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''',
            ''SELECT * FROM [medios de pago$]''
        )';

        EXEC sp_executesql @sql;
		
		--SELECT * FROM #tmpMedioDePago;
		
		INSERT INTO ventas.MedioPago (Descripcion_ESP, Descripcion_ENG)
		(
			SELECT tmp.ESP, tmp.ENG
				FROM #tmpMedioDePago tmp
				WHERE NOT EXISTS 
				( 
				SELECT 1 
					FROM ventas.MedioPago m
					WHERE tmp.ESP = m.Descripcion_ESP COLLATE Modern_Spanish_CI_AS OR tmp.ENG = m.Descripcion_ENG COLLATE Modern_Spanish_CI_AS
				)
		)
		
    END TRY
    BEGIN CATCH
        PRINT 'Error al importar el archivo Excel: ' + ERROR_MESSAGE();
    end catch

		DROP TABLE IF EXISTS #tmpMedioDePago;

end
SET NOCOUNT OFF