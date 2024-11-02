USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE [catalogo].[ObtenerValorDolar]
AS
BEGIN
DECLARE @URL NVARCHAR(MAX) = 'https://dolarapi.com/v1/dolares/oficial';
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
       @URL,
       'False'
Exec sp_OAMethod @Object, 'send'
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
IF((Select @ResponseText) <> '')
BEGIN
     DECLARE @json NVARCHAR(MAX) = (Select @ResponseText)
     SELECT venta
     FROM OPENJSON(@json)
          WITH (
                 moneda VARCHAR(10) '$.moneda',
                 casa VARCHAR(10) '$.casa',
                 nombre VARCHAR(10) '$.nombre',
                 compra VARCHAR(10) '$.compra',
                 venta VARCHAR(10) '$.venta',
                 fechaActualizacion NVARCHAR(20) '$.fechaActualizacion'
               );
END
ELSE
BEGIN
     DECLARE @ErroMsg NVARCHAR(30) = 'No data found.';
     Print @ErroMsg;
	 SELECT 1
END
Exec sp_OADestroy @Object
END