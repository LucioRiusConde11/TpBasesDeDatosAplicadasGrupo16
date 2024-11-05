USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE EncriptarEmpleado
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    BEGIN
        CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password123!';
    END;

    IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'CertificadoEmpleado')
    BEGIN
        CREATE CERTIFICATE CertificadoEmpleado
        WITH SUBJECT = 'Certificado para cifrado de la tabla Empleado';
    END;

    IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'ClaveSimetricaEmpleado')
    BEGIN
        CREATE SYMMETRIC KEY ClaveSimetricaEmpleado
        WITH ALGORITHM = AES_256
        ENCRYPTION BY CERTIFICATE CertificadoEmpleado;
    END;

    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

	DELETE FROM tienda.Sucursal
	DBCC CHECKIDENT ('Com2900G16.tienda.Sucursal', RESEED, 0)
    ALTER TABLE tienda.Empleado DROP CONSTRAINT IF EXISTS CK_Empleado_Legajo;
    ALTER TABLE tienda.Empleado DROP CONSTRAINT IF EXISTS CK_Empleado_DNI;
    ALTER TABLE tienda.Empleado DROP CONSTRAINT IF EXISTS CK_Empleado_Mail_Empresa;
    ALTER TABLE tienda.Empleado DROP CONSTRAINT IF EXISTS CK_Empleado_CUIL;
    ALTER TABLE tienda.Empleado DROP CONSTRAINT IF EXISTS CK_Empleado_Estado;

    UPDATE tienda.Empleado
    SET Nombre = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), Nombre),
        Apellido = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), Apellido),
        DNI = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), DNI),
        CUIL = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), CUIL),
        Mail_Empresa = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), Mail_Empresa);

    CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
END;
GO

CREATE OR ALTER PROCEDURE tienda.AltaEmpleado
    @Legajo VARCHAR(7),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @DNI VARCHAR(8),
    @Mail_Empresa VARCHAR(100),
    @CUIL VARCHAR(13),
    @Cargo VARCHAR(50),
    @Turno VARCHAR(25),
    @ID_Sucursal INT,
    @Estado BIT = 1
AS
BEGIN
    -- Abrir la clave sim?trica
    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    -- Validaci?n: verificar si el Legajo ya existe
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
        RETURN;
    END

    -- Insertar el nuevo empleado con encriptaci?n
    INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
    VALUES (
        @Legajo,
        ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Nombre),
        ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Apellido),
        ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @DNI),
        ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Mail_Empresa),
        ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @CUIL),
        @Cargo,
        @Turno,
        @ID_Sucursal,
        @Estado
    );

    -- Cerrar la clave sim?trica
    CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarEmpleado
    @ID INT,
    @Legajo VARCHAR(7),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @DNI VARCHAR(8),
    @Mail_Empresa VARCHAR(100),
    @CUIL VARCHAR(13),
    @Cargo VARCHAR(50),
    @Turno VARCHAR(25),
    @ID_Sucursal INT,
    @Estado BIT = 1
AS
BEGIN
    -- Abrir la clave sim?trica
    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    -- Validaci?n: verificar si el Legajo ya existe en otro registro
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo AND ID <> @ID)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
        RETURN;
    END

    -- Actualizar los datos del empleado con encriptaci?n
    UPDATE tienda.Empleado
    SET Legajo = @Legajo,
        Nombre = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Nombre),
        Apellido = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Apellido),
        DNI = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @DNI),
        Mail_Empresa = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @Mail_Empresa),
        CUIL = ENCRYPTBYKEY(KEY_GUID('ClaveSimetricaEmpleado'), @CUIL),
        Cargo = @Cargo,
        Turno = @Turno,
        ID_Sucursal = @ID_Sucursal,
        Estado = @Estado
    WHERE ID = @ID;

    -- Cerrar la clave sim?trica
    CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
END;
GO
CREATE OR ALTER PROCEDURE ventas.CrearUsuariosSupervisores
AS
BEGIN
    DECLARE @NombreUsuario NVARCHAR(100);
    DECLARE @Password NVARCHAR(50) = 'Password123!'; 
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
    WHERE Cargo = 'Supervisor' AND Estado = 1;

    -- Iniciar el ciclo
    WHILE @Contador <= (SELECT COUNT(*) FROM #Supervisores)
    BEGIN
        -- Obtener el nombre de usuario en base al ID actual
        SELECT @NombreUsuario = NombreUsuario
        FROM #Supervisores
        WHERE ID = @Contador;

        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE LOGIN ' + @NombreUsuario + ' WITH PASSWORD = ''' + @Password + ''', 
				DEFAULT_DATABASE=Com2900G16,CHECK_EXPIRATION=OFF,CHECK_POLICY=OFF;');
				PRINT ('Login creado:'+ @NombreUsuario);
            END

            IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE USER ' + @NombreUsuario + ' FOR LOGIN ' + @NombreUsuario + ';');
				PRINT ('User asociado a login:'+ @NombreUsuario);
            END

            EXEC('ALTER ROLE Supervisor ADD MEMBER ' + @NombreUsuario + ';');
			PRINT ('Rol asignado:'+ @NombreUsuario);

        END TRY
        BEGIN CATCH
            PRINT ('Error al crear o asignar el usuario'+ @NombreUsuario);
        END CATCH;
        SET @Contador = @Contador + 1;
    END
END;

GO

CREATE OR ALTER PROCEDURE ventas.CrearUsuariosSupervisores
AS
BEGIN
    DECLARE @Nombre NVARCHAR(50);
    DECLARE @Apellido NVARCHAR(50);
    DECLARE @NombreUsuario NVARCHAR(100);
    DECLARE @Password NVARCHAR(50) = 'Password123!';
    DECLARE @Contador INT = 1;

    CREATE TABLE #Supervisores (
        ID INT IDENTITY(1,1),
        Nombre NVARCHAR(50),
        Apellido NVARCHAR(50),
        NombreUsuario NVARCHAR(100)
    );

    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    INSERT INTO #Supervisores (Nombre, Apellido, NombreUsuario)
    SELECT 
        CONVERT(NVARCHAR(50), DECRYPTBYKEY(Nombre)),
        CONVERT(NVARCHAR(50), DECRYPTBYKEY(Apellido)),
        NULL -- Inicialmente vac?o; se llenar? luego en el ciclo
    FROM tienda.Empleado
    WHERE Cargo = 'Supervisor' AND Estado = 1;

    CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;

    UPDATE #Supervisores
    SET NombreUsuario = Nombre + Apellido;

    WHILE @Contador <= (SELECT COUNT(*) FROM #Supervisores)
    BEGIN
        SELECT @NombreUsuario = NombreUsuario
        FROM #Supervisores
        WHERE ID = @Contador;

        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE LOGIN ' + @NombreUsuario + ' WITH PASSWORD = ''' + @Password + ''', 
                    DEFAULT_DATABASE=Com2900G16, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;');
                PRINT ('Login creado: ' + @NombreUsuario);
            END

      
            IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @NombreUsuario)
            BEGIN
                EXEC('CREATE USER ' + @NombreUsuario + ' FOR LOGIN ' + @NombreUsuario + ';');
                PRINT ('Usuario asociado a login: ' + @NombreUsuario);
            END

      
            EXEC('ALTER ROLE Supervisor ADD MEMBER ' + @NombreUsuario + ';');
            PRINT ('Rol asignado: ' + @NombreUsuario);

        END TRY
        BEGIN CATCH
            PRINT ('Error al crear o asignar el usuario ' + @NombreUsuario);
        END CATCH;

	    SET @Contador = @Contador + 1;
    END
END;