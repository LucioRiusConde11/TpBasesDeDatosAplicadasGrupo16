USE Com2900G16;
GO
/*
--Alumnos
<Avella Mateo, 45318319
<Rius Conde Lucio, 41779534
<

GRUPO 16
ENTREGA: 05/11/24

Se requiere que importe toda la informaci�n antes mencionada a la base de datos:
	� Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
	archivos antes mencionados. Tenga en cuenta que cada mes se recibir�n archivos de
	novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
	� Considere este comportamiento al generar el c�digo. Debe admitir la importaci�n de
	novedades peri�dicamente.
	� Cada maestro debe importarse con un SP distinto. No se aceptar�n scripts que
	realicen tareas por fuera de un SP.
	� La estructura/esquema de las tablas a generar ser� decisi�n suya. Puede que deba
	realizar procesos de transformaci�n sobre los maestros recibidos para adaptarlos a la
	estructura requerida.
	� Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
	cargados, incompletos, err�neos, etc., deber� contemplarlo y realizar las correcciones
	en el fuente SQL. (Ser�a una excepci�n si el archivo est� malformado y no es posible
	interpretarlo como JSON o CSV). 

*/

-- Creaci�n de la tabla Sucursal
IF OBJECT_ID(N'tienda.Sucursal') IS NOT NULL
	DROP TABLE tienda.Sucursal;

CREATE TABLE tienda.Sucursal (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Direccion VARCHAR(100) NOT NULL UNIQUE,
    Ciudad VARCHAR(50) NOT NULL,
	Ciudad_anterior VARCHAR(50)
);

-- Creaci�n de la tabla Empleado
IF OBJECT_ID(N'tienda.Empleado') IS NOT NULL
	DROP TABLE tienda.Empleado;

CREATE TABLE tienda.Empleado (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Legajo CHAR(6) UNIQUE,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50),
    DNI CHAR(8), 
    MailEmpresa VARCHAR(100),
    CUIL CHAR(13),
    Cargo VARCHAR(20),
    Turno CHAR(2),
    ID_Sucursal INT NOT NULL,
    Estado BIT DEFAULT 1,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE NO ACTION,
    CHECK (Legajo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'), 
    CHECK (DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
    CHECK (MailEmpresa LIKE '%_@__%.__%'), 
    CHECK (CUIL LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'), 
    CHECK (Estado IN (0, 1)) 
);

-- Creaci�n de la tabl Cliente
IF OBJECT_ID(N'tienda.Cliente') IS NOT NULL
	DROP TABLE tienda.Cliente;

CREATE TABLE tienda.Cliente (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    TipoCliente VARCHAR(6) NOT NULL,
    Genero CHAR(1) NOT NULL, --Cambi�
    Estado BIT DEFAULT 1,
	CUIT CHAR(13),
	CHECK (TipoCliente IN ('Member', 'Normal')),
	CHECK (Genero IN ('F', 'M'))
);

-- Creaci�n de la tabla Linea Producto
IF OBJECT_ID(N'catalogo.CategoriaProducto') IS NOT NULL
	DROP TABLE catalogo.CategoriaProducto;

CREATE TABLE catalogo.CategoriaProducto (
    ID INT IDENTITY(1,1) PRIMARY KEY,
	LineaProducto VARCHAR(40),
	Categoria VARCHAR(100) NOT NULL UNIQUE
);

-- Creaci�n de la tabla Producto
IF OBJECT_ID(N'catalogo.Producto') IS NOT NULL
	DROP TABLE catalogo.Producto;

CREATE TABLE catalogo.Producto (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Categoria INT,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
	PrecioReferencia DECIMAL(10,2),
	UnidadReferencia VARCHAR(25),
    Fecha DATETIME NOT NULL,
	IVA DECIMAL(10, 2) DEFAULT 0.21,
	FOREIGN KEY (ID_Categoria) REFERENCES catalogo.CategoriaProducto (ID) ON DELETE NO ACTION
);

-- Creaci�n de la tabla MedioPago
IF OBJECT_ID(N'ventas.MedioPago') IS NOT NULL
	DROP TABLE ventas.MedioPago;

CREATE TABLE ventas.MedioPago (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion_ESP VARCHAR(50) NOT NULL UNIQUE,
	Descripcion_ENG VARCHAR(50) NOT NULL UNIQUE
);

-- Creaci�n de la tabla Factura
IF OBJECT_ID(N'ventas.Factura') IS NOT NULL
	DROP TABLE ventas.Factura;

CREATE TABLE ventas.Factura (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Estado VARCHAR(11),
	FechaHora DATETIME NOT NULL,
	Comprobante VARCHAR(10) NOT NULL,
	PuntoDeVenta CHAR(5) NOT NULL,
	SubTotal DECIMAL(10, 2) NOT NULL,
	IvaTotal DECIMAL(10, 2) NOT NULL,
	Total DECIMAL(10, 2) NOT NULL,
	CHECK (Estado IN ('Pagada', 'No pagada','Cancelada'))
);

IF OBJECT_ID(N'ventas.Pago') IS NOT NULL
    DROP TABLE ventas.Pago

CREATE TABLE ventas.Pago (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ID_Factura INT NOT NULL, 
	ID_MedioPago INT NOT NULL,
	Monto DECIMAL(18,2) NOT NULL, 
    Fecha_Pago DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID),
	FOREIGN KEY (ID_MedioPago) REFERENCES ventas.MedioPago(ID)
);

-- Creaci�n de la tabla DetalleFactura
IF OBJECT_ID(N'ventas.DetalleFactura') IS NOT NULL
	DROP TABLE ventas.DetalleFactura;

CREATE TABLE ventas.DetalleFactura (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_Factura INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
	IVA DECIMAL(18,2) NOT NULL,
	Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
);

-- Creaci�n de la tabla NotaCredito
IF OBJECT_ID(N'ventas.NotaCredito') IS NOT NULL
    DROP TABLE ventas.NotaCredito;

CREATE TABLE ventas.NotaCredito (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_Factura INT NOT NULL,
	ID_Cliente INT NOT NULL, 
	ID_Producto INT NOT NULL,
    FechaEmision DATETIME DEFAULT GETDATE(),
    Motivo VARCHAR(255), --Cambi�
	PuntoDeVenta CHAR(5) NOT NULL,--Cambi�
	Comprobante INT NOT NULL,
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
);

IF OBJECT_ID(N'ventas.Venta') IS NOT NULL
    DROP TABLE ventas.Venta;

CREATE TABLE ventas.Venta (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    ID_Cliente INT NULL, 
    Total DECIMAL(18,2) NOT NULL,
	id_factura_importado VARCHAR(30),
    Estado VARCHAR(11) NOT NULL,
	FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
	CHECK (Estado IN ('Pagada', 'No pagada','Cancelada'))
);

IF OBJECT_ID(N'ventas.DetalleVenta') IS NOT NULL
    DROP TABLE ventas.DetalleVenta

CREATE TABLE ventas.DetalleVenta (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ID_Venta INT NOT NULL,
    ID_Producto INT NOT NULL, 
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(18,2) NOT NULL,
    Subtotal AS (Cantidad * Precio_Unitario) PERSISTED,
    FOREIGN KEY (ID_Venta) REFERENCES ventas.Venta(ID)
);
