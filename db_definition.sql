USE master;

EXEC sp_configure 'contained database authentication',1;
RECONFIGURE;
GO

CREATE DATABASE GIMNASIO_DB containment = partial;
GO

USE GIMNASIO_DB;

CREATE TABLE Socio (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Fecha_nacimiento DATE,
    Telefono NVARCHAR (15) UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Fecha_registro DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(10) DEFAULT 'Activo' --Que nomas se inscriba, su estado sera en automatico "activo"
    CONSTRAINT chk_Estado CHECK (Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE Clase(
	Id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Id_Entrenador INT,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(200), --de clase
    Capacidad INT DEFAULT(20), --capacidad minima, se puede cambiar
    Hora_Inicio TIME,
    Hora_Fin TIME,
    Dia_Semana NVARCHAR(10) NOT NULL CONSTRAINT chk_dia_semana CHECK (Dia_Semana IN 
    ('Lunes', 'Martes','Miercoles','Jueves','Viernes','Sabado','Domingo'))
);

CREATE TABLE Entrenador (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100) UNIQUE,
    Especialidad NVARCHAR(100),
    sueldo DECIMAL(8,2)  
);

CREATE TABLE Grupo_de_Clase (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    horario NVARCHAR(100),
    capacidad INT,
	id_clase INT
);

CREATE TABLE Reserva (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    id_socio INT NOT NULL,
    id_grupo_de_clase INT NOT NULL,
    Fecha_Reserva DATETIME DEFAULT GETDATE(),
    Estado_Reserva NVARCHAR(10) NOT NULL CONSTRAINT chk_estado_reserva 
    CHECK(Estado_Reserva IN ('Activa','Cancelada','Completada')) DEFAULT 'Activa'
);

CREATE TABLE Pago (
    id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    id_socio INT NOT NULL,
    id_grupo_de_clase INT NOT NULL,        
    id_entrenador INT NOT NULL,
    Fecha_Pago DATETIME DEFAULT GETDATE(),
    Tipo_Pago NVARCHAR(10) NOT NULL CONSTRAINT chk_tipo_pago 
    CHECK (Tipo_Pago IN ('Mensual','Clase')),
    Metodo_Pago NVARCHAR(20) NOT NULL CONSTRAINT chk_metodo_pago 
    CHECK (Metodo_Pago IN ('Efectivo','Tarjeta','Transferencia')),     
    Monto DECIMAL(10,2) NOT NULL DEFAULT 0
);
GO

--Llaves foraneas
ALTER TABLE Reserva
ADD CONSTRAINT FK_Reserva_Socio
FOREIGN KEY (id_socio) REFERENCES Socio(Id);

ALTER TABLE Reserva
ADD CONSTRAINT FK_Reserva_GrupoDeClase
FOREIGN KEY (id_grupo_de_clase) REFERENCES Grupo_de_Clase(Id);

ALTER TABLE Pago
ADD CONSTRAINT FK_Pago_GrupoDeClase
FOREIGN KEY (id_grupo_de_clase) REFERENCES Grupo_de_Clase(Id);

ALTER TABLE Pago
ADD CONSTRAINT FK_Pago_Entrenador
FOREIGN KEY (id_entrenador) REFERENCES Entrenador(Id);

ALTER TABLE Pago
ADD CONSTRAINT FK_Pago_Socio
FOREIGN KEY (id_socio) REFERENCES Socio(Id);

ALTER TABLE Clase
ADD CONSTRAINT FK_Clase_Entrenador
FOREIGN KEY (Id_Entrenador) REFERENCES Entrenador(Id);

ALTER TABLE Grupo_de_Clase
ADD CONSTRAINT FK_GrupoDeClase_Clase
FOREIGN KEY (id_clase) REFERENCES Clase(Id);

--Datos quemados:



