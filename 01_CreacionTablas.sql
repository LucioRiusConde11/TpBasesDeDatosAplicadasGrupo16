use GRUPO_16

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
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100),
    DNI VARCHAR(8), --No hay DNI mas largo
	CUIL VARCHAR(13), --8 DNI, 3 numeros y 2 guiones = 13
    Cargo VARCHAR(50),
    Turno VARCHAR(25), --str(Jornada completa) es > 5
    ID_Sucursal INT NOT NULL,
    Estado BIT DEFAULT 1,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE NO ACTION
);

-- Creación de la tabla Cliente
/*
No parece fundamental la informacion del cliente
CREATE TABLE tienda.Cliente (
    ID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    TipoCliente VARCHAR(6) NOT NULL,
    Genero VARCHAR(6) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Estado BIT DEFAULT 1
);
*/

-- Creación de la tabla Linea Producto
IF OBJECT_ID(N'catalogo.CategoriaProducto') IS NOT NULL
	DROP TABLE catalogo.CategoriaProducto;

CREATE TABLE catalogo.CategoriaProducto (
    ID INT IDENTITY PRIMARY KEY,
	Categoria VARCHAR(100) NOT NULL UNIQUE,
	LineaProducto VARCHAR(40) 
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
    Descripcion VARCHAR(50) NOT NULL UNIQUE
);

-- Creación de la tabla EstadoFactura
/* --Podria ser una variable en la tabla factura?
CREATE TABLE ventas.EstadoFactura (
    ID INT IDENTITY PRIMARY KEY,
    Descripcion VARCHAR(10)
);
*/
-- Creación de la tabla Factura
IF OBJECT_ID(N'ventas.Factura') IS NOT NULL
	DROP TABLE ventas.Factura;

CREATE TABLE ventas.Factura (
    ID INT IDENTITY PRIMARY KEY,
    FechaHora DATETIME NOT NULL,
    Estado VARCHAR(10),
    ID_Cliente INT NOT NULL,
    ID_Empleado INT NOT NULL,
    --La sucursal se obtiene a traves de empleado
    ID_MedioPago INT NOT NULL,
    FOREIGN KEY (ID_Empleado) REFERENCES tienda.Empleado(ID) ON DELETE NO ACTION,
    FOREIGN KEY (ID_MedioPago) REFERENCES ventas.MedioPago(ID) ON DELETE NO ACTION,
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
	TipoCliente VARCHAR(10) CHECK (TipoCliente IN ('Member', 'Normal')),
	GeneroCliente VARCHAR(8) CHECK (GeneroCliente IN ('Female', 'Male')),
	IdentificadorPago VARCHAR(30),
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE NO ACTION
);
