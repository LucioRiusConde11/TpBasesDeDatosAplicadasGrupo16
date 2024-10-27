-- Creación de esquemas
CREATE SCHEMA IF NOT EXISTS tienda;
CREATE SCHEMA IF NOT EXISTS ventas;
CREATE SCHEMA IF NOT EXISTS catalogo;

USE tienda;

-- Creación de la tabla Sucursal
CREATE TABLE tienda.Sucursal (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Ubicacion VARCHAR(100) NOT NULL UNIQUE,
    Ciudad VARCHAR(50) NOT NULL
);

-- Creación de la tabla Empleado
CREATE TABLE tienda.Empleado (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100),
    DNI VARCHAR(20),
    Cargo VARCHAR(50),
    Turno VARCHAR(5),
    ID_Sucursal INT NOT NULL,
    Estado INT(1) DEFAULT 1,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE RESTRICT
);

-- Creación de la tabla Cliente
CREATE TABLE tienda.Cliente (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    TipoCliente VARCHAR(6) NOT NULL,
    Genero VARCHAR(6) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Estado INT(1) DEFAULT 1
);

USE catalogo;

-- Creación de la tabla Producto
CREATE TABLE catalogo.Producto (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    ClasificacionProducto VARCHAR(100),
    LineaProducto VARCHAR(50) NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL
);

USE ventas;

-- Creación de la tabla MedioPago
CREATE TABLE ventas.MedioPago (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(50) NOT NULL UNIQUE
);

-- Creación de la tabla Factura
CREATE TABLE ventas.Factura (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
    ID_Estado int NOT NULL,
    ID_Cliente INT NOT NULL,
    ID_Empleado INT NOT NULL,
    ID_Sucursal INT NOT NULL,
    ID_MedioPago INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES tienda.Cliente(ID) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Empleado) REFERENCES tienda.Empleado(ID) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Sucursal) REFERENCES tienda.Sucursal(ID) ON DELETE RESTRICT,
    FOREIGN KEY (ID_MedioPago) REFERENCES ventas.MedioPago(ID) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Estado) REFERENCES ventas.EstadoFactura(ID) ON DELETE RESTRICT
);

-- Creación de la tabla DetalleFactura
CREATE TABLE ventas.DetalleFactura (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    ID_Factura INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Factura) REFERENCES ventas.Factura(ID) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES catalogo.Producto(ID) ON DELETE RESTRICT
);

-- Creación de la tabla DetalleFactura
CREATE TABLE ventas.EstadoFactura (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(10)
);