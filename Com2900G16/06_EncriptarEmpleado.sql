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

	DECLARE @UltimoID INT;
	DECLARE @SQL NVARCHAR(100);
	SELECT @UltimoID = MAX(ID) FROM tienda.Empleado;

	IF OBJECT_ID(N'tienda.EmpleadoEncript') IS NOT NULL
		DROP TABLE tienda.Cliente;

	CREATE TABLE tienda.EmpleadoEncript (
    ID INT IDENTITY PRIMARY KEY,
    Legajo VARCHAR(6) UNIQUE,
    Nombre VARBINARY(255) NOT NULL,
    Apellido VARBINARY(255),
    DNI VARBINARY(255), 
    Mail_Empresa VARBINARY(255),
    CUIL VARBINARY(255),
    Cargo VARCHAR(50),
    Turno VARCHAR(25),
    ID_Sucursal INT NOT NULL,
    Estado BIT DEFAULT 1,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE CASCADE
	);
	SET @SQL = 'DBCC CHECKIDENT (''tienda.EmpleadoEncript'', RESEED, ' + CAST(@UltimoID AS NVARCHAR(10)) + ');';
	EXEC sp_executesql @SQL;


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
    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
        RETURN;
    END

    INSERT INTO tienda.EmpleadoEncript (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
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
    OPEN SYMMETRIC KEY ClaveSimetricaEmpleado
    DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo AND ID <> @ID)
    BEGIN
        PRINT ('Error: El legajo del empleado ya existe.');
        CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
        RETURN;
    END

    UPDATE tienda.EmpleadoEncript
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
    FROM tienda.EmpleadoEncript
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