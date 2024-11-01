USE Com2900G16;
GO

-- Procedimientos para la Tabla Sucursal
CREATE OR ALTER PROCEDURE tienda.AltaSucursal
    @Direccion VARCHAR(100),
    @Ciudad VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Sucursal WHERE Direccion = @Direccion)
    BEGIN
        RAISERROR ('Error: La direcci�n de la sucursal ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO tienda.Sucursal (Direccion, Ciudad)
    VALUES (@Direccion, @Ciudad);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaSucursal
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Sucursal WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarSucursal
    @ID INT,
    @Direccion VARCHAR(100),
    @Ciudad VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Sucursal WHERE Direccion = @Direccion AND ID <> @ID)
    BEGIN
        RAISERROR ('Error: La direcci�n de la sucursal ya existe.', 16, 1);
        RETURN;
    END

    UPDATE tienda.Sucursal
    SET Direccion = @Direccion,
        Ciudad = @Ciudad
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Empleado
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
    @Estado BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo)
    BEGIN
        RAISERROR ('Error: El legajo del empleado ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO tienda.Empleado (Legajo, Nombre, Apellido, DNI, Mail_Empresa, CUIL, Cargo, Turno, ID_Sucursal, Estado)
    VALUES (@Legajo, @Nombre, @Apellido, @DNI, @Mail_Empresa, @CUIL, @Cargo, @Turno, @ID_Sucursal, @Estado);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaEmpleado
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Empleado WHERE ID = @ID;
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
    @Estado BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tienda.Empleado WHERE Legajo = @Legajo AND ID <> @ID)
    BEGIN
        RAISERROR ('Error: El legajo del empleado ya existe.', 16, 1);
        RETURN;
    END

    UPDATE tienda.Empleado
    SET Legajo = @Legajo,
        Nombre = @Nombre,
        Apellido = @Apellido,
        DNI = @DNI,
        Mail_Empresa = @Mail_Empresa,
        CUIL = @CUIL,
        Cargo = @Cargo,
        Turno = @Turno,
        ID_Sucursal = @ID_Sucursal,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Cliente
CREATE OR ALTER PROCEDURE tienda.AltaCliente
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero VARCHAR(6),
    @Estado BIT
AS
BEGIN
    IF @TipoCliente NOT IN ('Member', 'Normal')
    BEGIN
        RAISERROR ('Error: Tipo de cliente inv�lido.', 16, 1);
        RETURN;
    END

    IF @Genero NOT IN ('Female', 'Male')
    BEGIN
        RAISERROR ('Error: G�nero inv�lido.', 16, 1);
        RETURN;
    END

    INSERT INTO tienda.Cliente (Nombre, TipoCliente, Genero, Estado)
    VALUES (@Nombre, @TipoCliente, @Genero, @Estado);
END;
GO

CREATE OR ALTER PROCEDURE tienda.BajaCliente
    @ID INT
AS
BEGIN
    DELETE FROM tienda.Cliente WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE tienda.ModificarCliente
    @ID INT,
    @Nombre VARCHAR(100),
    @TipoCliente VARCHAR(6),
    @Genero VARCHAR(6),
    @Estado BIT
AS
BEGIN
    IF @TipoCliente NOT IN ('Member', 'Normal')
    BEGIN
        RAISERROR ('Error: Tipo de cliente inv�lido.', 16, 1);
        RETURN;
    END

    IF @Genero NOT IN ('Female', 'Male')
    BEGIN
        RAISERROR ('Error: G�nero inv�lido.', 16, 1);
        RETURN;
    END

    UPDATE tienda.Cliente
    SET Nombre = @Nombre,
        TipoCliente = @TipoCliente,
        Genero = @Genero,
        Estado = @Estado
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla CategoriaProducto
CREATE OR ALTER PROCEDURE catalogo.AltaCategoriaProducto
    @LineaProducto VARCHAR(40),
    @Categoria VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM catalogo.CategoriaProducto WHERE Categoria = @Categoria)
    BEGIN
        RAISERROR ('Error: La categor�a ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO catalogo.CategoriaProducto (LineaProducto, Categoria)
    VALUES (@LineaProducto, @Categoria);
END;
GO

CREATE OR ALTER PROCEDURE catalogo.BajaCategoriaProducto
    @ID INT
AS
BEGIN
    DELETE FROM catalogo.CategoriaProducto WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE catalogo.ModificarCategoriaProducto
    @ID INT,
    @LineaProducto VARCHAR(40),
    @Categoria VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM catalogo.CategoriaProducto WHERE Categoria = @Categoria AND ID <> @ID)
    BEGIN
        RAISERROR ('Error: La categor�a ya existe.', 16, 1);
        RETURN;
    END

    UPDATE catalogo.CategoriaProducto
    SET LineaProducto = @LineaProducto,
        Categoria = @Categoria
    WHERE ID = @ID;
END;
GO

-- Procedimientos para la Tabla Producto
CREATE OR ALTER PROCEDURE catalogo.AltaProducto
    @Nombre VARCHAR(100),
    @ID_Categoria INT,
    @PrecioUnitario DECIMAL(10, 2),
    @PrecioReferencia DECIMAL(10, 2),
    @UnidadReferencia VARCHAR(10),
    @Fecha DATETIME
AS
BEGIN
    IF @PrecioUnitario <= 0
    BEGIN
        RAISERROR ('Error: Precio unitario debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    INSERT INTO catalogo.Producto (Nombre, ID_Categoria, PrecioUnitario, PrecioReferencia, UnidadReferencia, Fecha)
    VALUES (@Nombre, @ID_Categoria, @PrecioUnitario, @PrecioReferencia, @UnidadReferencia, @Fecha);
END;
GO

CREATE OR ALTER PROCEDURE catalogo.BajaProducto
    @ID INT
AS
BEGIN
    DELETE FROM catalogo.Producto WHERE ID = @ID;
END;
GO

CREATE OR ALTER PROCEDURE catalogo.ModificarProducto
    @ID INT,
    @Nombre VARCHAR(100),
    @ID_Categoria INT,
    @PrecioUnitario DECIMAL(10, 2),
    @PrecioReferencia DECIMAL(10, 2),
    @UnidadReferencia VARCHAR(10),
    @Fecha DATETIME
AS
BEGIN
    IF @PrecioUnitario <= 0
    BEGIN
        RAISERROR ('Error: Precio unitario debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    UPDATE catalogo.Producto
    SET Nombre = @Nombre,
        ID_Categoria = @ID_Categoria,
        PrecioUnitario = @PrecioUnitario,
        PrecioReferencia = @PrecioReferencia,
        UnidadReferencia = @UnidadReferencia,
        Fecha = @Fecha
    WHERE ID = @ID;
END;
GO

-- Procedimiento para Generar Nota de Cr�dito
CREATE OR ALTER PROCEDURE ventas.CrearNotaCredito
    @ID_Factura INT,
    @ID_Cliente INT,
    @ID_Producto INT,
    @Motivo VARCHAR(255)
AS
BEGIN
    -- Verificar que exista la factura para el cliente con el producto espec�fico
    IF EXISTS (
        SELECT 1 
        FROM ventas.Factura AS f
        JOIN ventas.DetalleFactura AS df ON f.ID = df.ID_Factura
        WHERE f.ID = @ID_Factura 
          AND f.ID_Cliente = @ID_Cliente
          AND df.ID_Producto = @ID_Producto
    )
    BEGIN
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Insertar en la tabla NotaCredito
            INSERT INTO ventas.NotaCredito (ID_Factura, ID_Cliente, ID_Producto, Motivo)
            VALUES (@ID_Factura, @ID_Cliente, @ID_Producto, @Motivo);

            -- Actualizar el precio unitario en la tabla DetalleFactura para reflejar el reembolso
            UPDATE ventas.DetalleFactura
            SET PrecioUnitario = 0
            WHERE ID_Factura = @ID_Factura
              AND ID_Producto = @ID_Producto;

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            RAISERROR('Error al crear la nota de cr�dito o al actualizar el detalle de la factura.', 16, 1);
        END CATCH;
    END
    ELSE
    BEGIN
        RAISERROR('Error: No existe una factura con el producto especificado para el cliente.', 16, 1);
    END
END;
GO
