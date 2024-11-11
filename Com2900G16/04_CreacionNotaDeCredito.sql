USE Com2900G16;

-- Procedimiento para Generar Nota de Cr�dito
GO
CREATE OR ALTER PROCEDURE ventas.CrearNotaCredito
    @ID_Factura INT,
    @ID_Producto INT,
	@IdCliente INT,
    @Motivo VARCHAR(255),
	@PuntoDeVenta CHAR(5),
	@Comprobante INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM ventas.Factura AS f
        JOIN ventas.DetalleFactura AS df ON f.ID = df.ID_Factura
        WHERE f.ID = @ID_Factura 
		  AND f.ID_Cliente = @idCliente
          AND df.ID_Producto = @ID_Producto
		  AND f.Estado = 'Pagada' 
    )
    BEGIN
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Insertar en la tabla NotaCredito
            INSERT INTO ventas.NotaCredito (ID_Factura, ID_Cliente, ID_Producto, Motivo,PuntoDeVenta,Comprobante)
            VALUES (@ID_Factura,@IdCliente, @ID_Producto, @Motivo,@PuntoDeVenta,@Comprobante);

            -- Actualizar el precio unitario en la tabla DetalleFactura para reflejar el reembolso
            UPDATE ventas.DetalleFactura
            SET PrecioUnitario = 0
            WHERE ID_Factura = @ID_Factura
              AND ID_Producto = @ID_Producto;

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT('Error al crear la nota de cr�dito o al actualizar el detalle de la factura.');
        END CATCH;
    END
    ELSE
        PRINT('Error: No existe una factura con el producto especificado para el cliente.');
END;
GO

GO
CREATE OR ALTER PROCEDURE ventas.CrearRolSupervisor
AS  
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Supervisor')
    BEGIN
        EXEC('CREATE ROLE Supervisor');
    END

    GRANT EXECUTE ON ventas.CrearNotaCredito TO Supervisor;
    GRANT SELECT ON schema::ventas TO Supervisor;
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