/*
--Alumnos
<Avella Mateo, 45318319
<Rius Conde Lucio, 41779534
<

GRUPO 16
ENTREGA: 05/11/24

Se requiere que importe toda la información antes mencionada a la base de datos:
	• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
	archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
	novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
	• Considere este comportamiento al generar el código. Debe admitir la importación de
	novedades periódicamente.
	• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
	realicen tareas por fuera de un SP.
	• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
	realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
	estructura requerida.
	• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
	cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
	en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
	interpretarlo como JSON o CSV). 

*/
USE Com2900G16;
GO
CREATE OR ALTER PROCEDURE tienda.EliminarTablasEmpleado
AS
BEGIN

    IF OBJECT_ID(N'ventas.DetalleFactura') IS NOT NULL
        DROP TABLE ventas.DetalleFactura;

    IF OBJECT_ID(N'ventas.NotaCredito') IS NOT NULL
        DROP TABLE ventas.NotaCredito;

    IF OBJECT_ID(N'ventas.Factura') IS NOT NULL
        DROP TABLE ventas.Factura;

    IF OBJECT_ID(N'tienda.Empleado') IS NOT NULL
        DROP TABLE tienda.Empleado;
    PRINT 'Eliminación de tablas completada.';
END;
GO

CREATE OR ALTER PROCEDURE tienda.EncriptarEmpleado
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
        CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password123!';

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

	EXEC tienda.EliminarTablasEmpleado;

	CREATE TABLE tienda.Empleado (
	   ID INT IDENTITY PRIMARY KEY,
	   Legajo VARCHAR(6) UNIQUE,
	   Nombre VARBINARY(255) NOT NULL,
	   Apellido VARBINARY(255),
	   DNI VARBINARY(255), 
	   Mail_Empresa VARBINARY(255),
	   CUIL VARBINARY(255),
	   Cargo VARCHAR(20),
	   Turno CHAR(2),
	   ID_Sucursal INT NOT NULL,
	   Estado BIT DEFAULT 1,
	   FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE  NO ACTION
	);
	   CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;

	CREATE TABLE ventas.Factura (
	    ID INT IDENTITY PRIMARY KEY,
	    FechaHora DATETIME NOT NULL,
	    Estado VARCHAR(10),
	    ID_Cliente INT NOT NULL,
	    ID_Empleado INT NOT NULL,
	    ID_Sucursal INT NOT NULL,
	    ID_MedioPago INT NOT NULL,
		id_factura_importado VARCHAR(30),
		PuntoDeVenta CHAR(5) NOT NULL,
		Comprobante INT NOT NULL,
	    FOREIGN KEY (ID_Empleado) REFERENCES tienda.Empleado(ID) ON DELETE NO ACTION,
	    FOREIGN KEY (ID_MedioPago) REFERENCES ventas.MedioPago(ID) ON DELETE NO ACTION,
		FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
		FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE NO ACTION,
		CHECK (Estado IN ('Pagada', 'No pagada'))
	);
	
	CREATE TABLE ventas.DetalleFactura (
	    ID INT IDENTITY PRIMARY KEY,
	    ID_Factura INT NOT NULL,
	    ID_Producto INT NOT NULL,
	    Cantidad INT NOT NULL,
	    PrecioUnitario DECIMAL(10, 2) NOT NULL,
		IdentificadorPago VARCHAR(30),
	    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE CASCADE,
	    FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
	);

	CREATE TABLE ventas.NotaCredito (
	    ID INT IDENTITY PRIMARY KEY,
	    ID_Factura INT NOT NULL,
		ID_Cliente INT NOT NULL,
		ID_Producto INT NOT NULL,
	    FechaEmision DATETIME DEFAULT GETDATE(),
	    Motivo VARCHAR(255),
		PuntoDeVenta CHAR(5) NOT NULL,
		Comprobante INT NOT NULL,
	    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE NO ACTION,
		FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
		FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
	);

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

    CLOSE SYMMETRIC KEY ClaveSimetricaEmpleado;
END;
GO

