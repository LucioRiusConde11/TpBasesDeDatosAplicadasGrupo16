USE Com2900G16;
GO
/*
Reportes:
	El sistema debe ofrecer los siguientes reportes en xml.
	Mensual: ingresando un mes y año determinado mostrar el total facturado por días de
	la semana, incluyendo sábado y domingo.
	Trimestral: mostrar el total facturado por turnos de trabajo por mes.
	Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar
	la cantidad de productos vendidos en ese rango, ordenado de mayor a menor.
	Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar
	la cantidad de productos vendidos en ese rango por sucursal, ordenado de mayor a
	menor.
	Mostrar los 5 productos más vendidos en un mes, por semana
	Mostrar los 5 productos menos vendidos en el mes.
	Mostrar total acumulado de ventas (o sea tambien mostrar el detalle) para una fecha
	y sucursal particulares
*/

-- Creación de la tabla Sucursal
IF OBJECT_ID(N'tienda.Sucursal') IS NOT NULL
	DROP TABLE tienda.Sucursal;

CREATE TABLE tienda.Sucursal (
    ID INT IDENTITY PRIMARY KEY,
    Direccion VARCHAR(100) NOT NULL UNIQUE,
    Ciudad VARCHAR(50) NOT NULL
);

-- Creación de la tabla Empleado
IF OBJECT_ID(N'tienda.Empleado') IS NOT NULL
	DROP TABLE tienda.Empleado;

CREATE TABLE tienda.Empleado (
    ID INT IDENTITY PRIMARY KEY,
    Legajo VARCHAR(7) UNIQUE,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50),
    DNI VARCHAR(8), 
    Mail_Empresa VARCHAR(100),
    CUIL VARCHAR(13),
    Cargo VARCHAR(50),
    Turno VARCHAR(25),
    ID_Sucursal INT NOT NULL,
    Estado BIT DEFAULT 1,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE NO ACTION,
    CHECK (Legajo LIKE '[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]'), 
    CHECK (DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
    CHECK (Mail_Empresa LIKE '%_@__%.__%'), 
    CHECK (CUIL LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'), 
    CHECK (Estado IN (0, 1)) 
);

-- Creación de la tabl Cliente
IF OBJECT_ID(N'tienda.Cliente') IS NOT NULL
	DROP TABLE tienda.Cliente;

CREATE TABLE tienda.Cliente (--Me parece que es relevante poner al cliente, no queda tan bien que solo sea un atributo
    ID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    TipoCliente VARCHAR(6) NOT NULL,
    Genero VARCHAR(6) NOT NULL,
    Estado BIT DEFAULT 1,
	CHECK (TipoCliente IN ('Member', 'Normal')),
	CHECK (Genero IN ('Female', 'Male'))
);

-- Creación de la tabla Linea Producto
IF OBJECT_ID(N'catalogo.CategoriaProducto') IS NOT NULL
	DROP TABLE catalogo.CategoriaProducto;

CREATE TABLE catalogo.CategoriaProducto (
    ID INT IDENTITY PRIMARY KEY,
	LineaProducto VARCHAR(40),
	Categoria VARCHAR(100) NOT NULL UNIQUE
);

-- Creación de la tabla Producto
IF OBJECT_ID(N'catalogo.Producto') IS NOT NULL
	DROP TABLE catalogo.Producto;

CREATE TABLE catalogo.Producto (
    ID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Categoria INT,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
	PrecioReferencia DECIMAL(10,2),
	UnidadReferencia VARCHAR(10),
    Fecha DATETIME NOT NULL,
	FOREIGN KEY (ID_Categoria) REFERENCES catalogo.CategoriaProducto (ID) ON DELETE NO ACTION
	--Precio de Referencia y unidad de referencia
	--ayudaria a mostrar el precio total por unidad de 
	--referencia, siempre esta en los supermercados
	--ademas le dieron importancia en el foro
);

-- Creación de la tabla MedioPago
IF OBJECT_ID(N'ventas.MedioPago') IS NOT NULL
	DROP TABLE ventas.MedioPago;

CREATE TABLE ventas.MedioPago (
    ID INT IDENTITY PRIMARY KEY,
    Descripcion_ESP VARCHAR(50) NOT NULL UNIQUE,
	Descripcion_ENG VARCHAR(50) NOT NULL UNIQUE
);

-- Creación de la tabla Factura
IF OBJECT_ID(N'ventas.Factura') IS NOT NULL
	DROP TABLE ventas.Factura;

CREATE TABLE ventas.Factura (
    ID INT IDENTITY PRIMARY KEY,
    FechaHora DATETIME NOT NULL,
    Estado VARCHAR(10),
    ID_Cliente INT NOT NULL,
    ID_Empleado INT NOT NULL,
    ID_Sucursal INT NOT NULL,
    ID_MedioPago INT NOT NULL,
    FOREIGN KEY (ID_Empleado) REFERENCES tienda.Empleado(ID) ON DELETE NO ACTION,
    FOREIGN KEY (ID_MedioPago) REFERENCES ventas.MedioPago(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE NO ACTION,
	CHECK (Estado IN ('Pagada', 'No pagada'))
);

-- Creación de la tabla DetalleFactura
IF OBJECT_ID(N'ventas.DetalleFactura') IS NOT NULL
	DROP TABLE ventas.DetalleFactura;

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

-- Creación de la tabla NotaCredito
IF OBJECT_ID(N'ventas.NotaCredito') IS NOT NULL
    DROP TABLE ventas.NotaCredito;

CREATE TABLE ventas.NotaCredito (--Un cliente realiza una nota de credito por un producto de la compra que hizo
    ID INT IDENTITY PRIMARY KEY,
    ID_Factura INT NOT NULL,
	ID_Cliente INT NOT NULL,
	ID_Producto INT NOT NULL,
    FechaEmision DATETIME DEFAULT GETDATE(),
    Motivo VARCHAR(255),
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE NO ACTION,
	FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
);
