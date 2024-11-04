USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE ventas.CrearRolSupervisor
AS  
BEGIN
	IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name =
	'Supervisor')
	BEGIN
		EXEC('CREATE ROLE Supervisor');
	END
	GRANT EXECUTE ON ventas.CrearNotaCredito TO Supervisor;
END;

GO
CREATE OR ALTER PROCEDURE ventas.CrearUsuariosSupervisores
AS
BEGIN
    DECLARE @NombreUsuario NVARCHAR(100);
    DECLARE @Password NVARCHAR(50) = 'Contraseña'; 
    DECLARE @Contador INT = 1;

    -- Crear una tabla temporal para almacenar los nombres de usuario de los Supervisores
    CREATE TABLE #Supervisores  (
        ID INT IDENTITY(1,1),
        NombreUsuario NVARCHAR(100)
    );

    -- Insertar en la tabla temporal los nombres de usuario de los empleados con cargo 'Supervisor'
    INSERT INTO #Supervisores (NombreUsuario)
    SELECT Nombre + Apellido
    FROM tienda.Empleado
    WHERE Cargo = 'Supervisor';

    -- Iniciar el ciclo
    WHILE @Contador <= (SELECT COUNT(*) FROM #Supervisores)
    BEGIN
        -- Obtener el nombre de usuario en base al ID actual
        SELECT @NombreUsuario = NombreUsuario
        FROM #Supervisores
        WHERE ID = @Contador;

        BEGIN TRY
            -- Crear un Login en la instancia de SQL Server (si no existe)
            IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE LOGIN ' + @NombreUsuario + ' WITH PASSWORD = ''' + @Password + ''';');
            END

            -- Crear un Usuario en la base de datos (si no existe) y asociarlo al Login
            IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE USER ' + @NombreUsuario + ' FOR LOGIN ' + @NombreUsuario + ';');
            END

            -- Asignar el rol Supervisor al Usuario
            EXEC('ALTER ROLE Supervisor ADD MEMBER ' + @NombreUsuario + ';');
        END TRY
        BEGIN CATCH
            PRINT ('Error al crear o asignar el usuario'+ @NombreUsuario);
        END CATCH;
        SET @Contador = @Contador + 1;
    END
END;