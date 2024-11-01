USE GRUPO_16
GO
SET NOCOUNT ON;
IF OBJECT_ID(N'catalogo.utf8_ascii') IS NOT NULL
	DROP TABLE catalogo.utf8_ascii;
	GO

CREATE TABLE catalogo.utf8_ascii(
		id int identity(1,1),
		utf8 NCHAR(2),
		ascii char(1)
);

INSERT INTO catalogo.utf8_ascii
	VALUES 
	('Ã¡', 'á'),
	('Ã‰', 'É'),
	('Ã©', 'é'),
	(CONCAT('Ã', NCHAR(173)), 'í'), --CARACTER INVISIBLE
	('Ã“', 'Ó'),
	(CONCAT('Ã', NCHAR(179)), 'ó'),
	('Ãš', 'Ú'),
	('Ãº', 'ú'),
	('Ã‘', 'Ñ'),
	('Ã±', 'ñ'),
	('Ãœ', 'Ü'),
	('Ã¼', 'ü'),
	('ÃŒ', 'Í'),
	(CONCAT('Ã', NCHAR(129)), 'Á') --CARACTER INVISIBLE

IF OBJECT_ID(N'catalogo.fnNormalizar', N'FN') IS NOT NULL
	DROP FUNCTION catalogo.fnNormalizar;
GO

CREATE OR ALTER FUNCTION catalogo.fnNormalizar (@string VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @indice int,
			@total int,
			@utf_8 nchar(2),
			@ascii char(1)

	SET @indice = (SELECT MIN(id) FROM catalogo.utf8_ascii);
	SET @total = (SELECT MAX(id) FROM catalogo.utf8_ascii);

	IF NOT EXISTS (SELECT 1 WHERE @string LIKE '%Ã%' OR @string LIKE '%å%')
		RETURN @string;
	
	WHILE @indice <= @total
	BEGIN
		SET @utf_8 = (SELECT TOP(1) utf8 FROM catalogo.utf8_ascii WHERE id = @indice);
		SET @ascii = (SELECT TOP(1) ascii FROM catalogo.utf8_ascii WHERE id = @indice);

		SET @string = REPLACE(@string, @utf_8, @ascii) COLLATE Latin1_General_CI_AS;
		SET @indice = @indice + 1;
	END;
	SET @string = REPLACE(@string, 'å˜','ñ') COLLATE Latin1_General_CI_AS; --caso especial
	RETURN @string;
END
GO
SET NOCOUNT OFF;



--SELECT *
--	FROM catalogo.utf8_ascii
--	WHERE utf8 LIKE '%as%' COLLATE Latin1_General_CI_AS

