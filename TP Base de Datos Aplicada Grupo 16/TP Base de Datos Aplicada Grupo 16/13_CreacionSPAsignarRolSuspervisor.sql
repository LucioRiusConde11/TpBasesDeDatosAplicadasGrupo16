USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE CrearUsuariosSupervisores
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
    WHERE Cargo = 'Supervisor' OR Cargo = 'supervisor';

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
                EXEC('CREATE LOGIN ' + QUOTENAME(@NombreUsuario) + ' WITH PASSWORD = ''' + @Password + ''';');
            END

            -- Crear un Usuario en la base de datos (si no existe) y asociarlo al Login
            IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE USER ' + QUOTENAME(@NombreUsuario) + ' FOR LOGIN ' + QUOTENAME(@NombreUsuario) + ';');
            END

            -- Asignar el rol Supervisor al Usuario
            EXEC('ALTER ROLE Supervisor ADD MEMBER ' + QUOTENAME(@NombreUsuario) + ';');

            PRINT 'Usuario ' + @NombreUsuario + ' creado y asignado al rol Supervisor.';
        END TRY
        BEGIN CATCH
            RAISERROR ('Error al crear o asignar el usuario ' + @NombreUsuario);
        END CATCH;

        -- Incrementar el contador
        SET @Contador = @Contador + 1;
    END
END;