USE master;

EXEC sp_configure 'contained database authentication',1;
RECONFIGURE;
GO

CREATE DATABASE GIMNASIO_DB containment = partial;

USE GIMNASIO_DB;

CREATE TABLE Socio (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Fecha_nacimiento DATE,
    Telefono NVARCHAR (15) UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Fecha_registro DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(10) DEFAULT 'Activo'
    CONSTRAINT chk_Estado CHECK (Estado IN ('Activo', 'Inactivo'))
);

CREATE TABLE Clase(
	Id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Id_Entrenador INT,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(200),
    Capacidad INT DEFAULT(20),
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
    id_grupo_de_clase INT NULL,        
    id_entrenador INT NULL,
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
INSERT INTO Socio (Nombre, Apellido, Fecha_nacimiento, Telefono, Email, Estado) VALUES
('Juan', 'Pérez', '1990-05-15', '555-1234', 'juan.perez@email.com', 'Activo'),
('María', 'Gómez', '1985-08-22', '555-5678', 'maria.gomez@email.com', 'Activo'),
('Carlos', 'López', '1992-03-10', '555-9012', 'carlos.lopez@email.com', 'Activo'),
('Ana', 'Martínez', '1988-11-30', '555-3456', 'ana.martinez@email.com', 'Inactivo'),
('Luis', 'Rodríguez', '1995-07-18', '555-7890', 'luis.rodriguez@email.com', 'Activo'),
('Sofía', 'Hernández', '1991-12-05', '555-2345', 'sofia.hernandez@email.com', 'Activo'),
('Pedro', 'Díaz', '1987-04-25', '555-6789', 'pedro.diaz@email.com', 'Activo'),
('Laura', 'Torres', '1993-09-12', '555-0123', 'laura.torres@email.com', 'Inactivo'),
('Miguel', 'Sánchez', '1989-06-08', '555-4567', 'miguel.sanchez@email.com', 'Activo'),
('Elena', 'Ramírez', '1994-01-20', '555-8901', 'elena.ramirez@email.com', 'Activo'),
('Jorge', 'Flores', '1986-02-14', '555-1357', 'jorge.flores@email.com', 'Activo'),
('Carmen', 'Vargas', '1990-10-03', '555-2468', 'carmen.vargas@email.com', 'Inactivo'),
('Fernando', 'Castro', '1984-07-29', '555-3579', 'fernando.castro@email.com', 'Activo'),
('Isabel', 'Reyes', '1992-08-17', '555-4680', 'isabel.reyes@email.com', 'Activo'),
('Ricardo', 'Morales', '1988-05-11', '555-5791', 'ricardo.morales@email.com', 'Activo'),
('Patricia', 'Ortega', '1991-11-23', '555-6802', 'patricia.ortega@email.com', 'Inactivo'),
('Roberto', 'Guerrero', '1987-03-07', '555-7913', 'roberto.guerrero@email.com', 'Activo'),
('Diana', 'Mendoza', '1993-12-15', '555-8024', 'diana.mendoza@email.com', 'Activo'),
('Antonio', 'Silva', '1985-09-28', '555-9135', 'antonio.silva@email.com', 'Activo'),
('Gabriela', 'Rojas', '1994-04-02', '555-0246', 'gabriela.rojas@email.com', 'Inactivo'),
('Francisco', 'Navarro', '1989-01-19', '555-1358', 'francisco.navarro@email.com', 'Activo'),
('Verónica', 'Cruz', '1990-06-24', '555-2469', 'veronica.cruz@email.com', 'Activo'),
('José', 'Mejía', '1986-08-13', '555-3570', 'jose.mejia@email.com', 'Activo'),
('Teresa', 'Acosta', '1992-02-09', '555-4681', 'teresa.acosta@email.com', 'Inactivo'),
('Alejandro', 'Miranda', '1988-10-31', '555-5792', 'alejandro.miranda@email.com', 'Activo');


INSERT INTO Entrenador (Nombre, Correo, Especialidad, sueldo) VALUES
('Carlos Rivera', 'carlos.rivera@gimnasio.com', 'CrossFit', 2500.00),
('Ana García', 'ana.garcia@gimnasio.com', 'Yoga', 2200.00),
('Miguel Torres', 'miguel.torres@gimnasio.com', 'Spinning', 2300.00),
('Laura Mendoza', 'laura.mendoza@gimnasio.com', 'Pilates', 2100.00),
('Roberto Sánchez', 'roberto.sanchez@gimnasio.com', 'Boxeo', 2400.00),
('Sofia Castro', 'sofia.castro@gimnasio.com', 'Zumba', 2000.00),
('Javier López', 'javier.lopez@gimnasio.com', 'Musculación', 2600.00),
('Elena Ruiz', 'elena.ruiz@gimnasio.com', 'TRX', 2350.00),
('Diego Herrera', 'diego.herrera@gimnasio.com', 'Natación', 2450.00),
('Patricia Vargas', 'patricia.vargas@gimnasio.com', 'Aeróbicos', 2150.00),
('Andrés Morales', 'andres.morales@gimnasio.com', 'Artes Marciales', 2550.00),
('Lucía Ortega', 'lucia.ortega@gimnasio.com', 'Danza', 2050.00),
('Raúl Jiménez', 'raul.jimenez@gimnasio.com', 'Funcional', 2420.00),
('Carmen Díaz', 'carmen.diaz@gimnasio.com', 'Stretching', 2080.00),
('Oscar Flores', 'oscar.flores@gimnasio.com', 'Calistenia', 2380.00),
('Mónica Reyes', 'monica.reyes@gimnasio.com', 'HIIT', 2320.00),
('Héctor Silva', 'hector.silva@gimnasio.com', 'Powerlifting', 2650.00),
('Adriana Cruz', 'adriana.cruz@gimnasio.com', 'Cardio', 2120.00),
('Sergio Navarro', 'sergio.navarro@gimnasio.com', 'Cross Training', 2480.00),
('Daniela Rojas', 'daniela.rojas@gimnasio.com', 'Pilates Reformer', 2250.00),
('Jorge Mejía', 'jorge.mejia@gimnasio.com', 'Boxeo Fitness', 2370.00),
('Rosa Acosta', 'rosa.acosta@gimnasio.com', 'Yoga Aéreo', 2180.00),
('Felipe Miranda', 'felipe.miranda@gimnasio.com', 'Spinning Avanzado', 2410.00),
('Natalia Guzmán', 'natalia.guzman@gimnasio.com', 'Zumba Toning', 2070.00),
('Alberto Núñez', 'alberto.nunez@gimnasio.com', 'Entrenamiento Funcional', 2430.00);

INSERT INTO Clase (Id_Entrenador, Nombre, Descripcion, Capacidad, Hora_Inicio, Hora_Fin, Dia_Semana) VALUES
(1, 'CrossFit Intenso', 'Entrenamiento funcional de alta intensidad', 15, '07:00', '08:00', 'Lunes'),
(2, 'Yoga Matutino', 'Yoga para empezar el día con energía', 20, '08:00', '09:00', 'Lunes'),
(3, 'Spinning Cardio', 'Clase de spinning para quemar calorías', 25, '09:00', '10:00', 'Lunes'),
(4, 'Pilates Básico', 'Pilates para principiantes', 18, '10:00', '11:00', 'Lunes'),
(5, 'Boxeo Fitness', 'Boxeo para acondicionamiento físico', 12, '17:00', '18:00', 'Lunes'),
(6, 'Zumba Party', 'Baile y diversión para quemar grasa', 30, '18:00', '19:00', 'Lunes'),
(1, 'CrossFit Avanzado', 'Para alumnos con experiencia', 12, '07:00', '08:00', 'Martes'),
(2, 'Yoga Restaurativo', 'Yoga para relajación y flexibilidad', 20, '08:00', '09:00', 'Martes'),
(7, 'Musculación Guiada', 'Técnica correcta en ejercicios con peso', 15, '09:00', '10:00', 'Martes'),
(8, 'TRX Total', 'Entrenamiento en suspensión', 16, '17:00', '18:00', 'Martes'),
(9, 'Natación Adultos', 'Clase de natación para adultos', 10, '18:00', '19:00', 'Martes'),
(10, 'Aeróbicos Activos', 'Ejercicios aeróbicos variados', 25, '19:00', '20:00', 'Martes'),
(3, 'Spinning Intermedio', 'Nivel intermedio de spinning', 20, '07:00', '08:00', 'Miercoles'),
(4, 'Pilates Intermedio', 'Pilates para nivel intermedio', 18, '08:00', '09:00', 'Miercoles'),
(11, 'Kickboxing', 'Artes marciales mixtas para fitness', 14, '09:00', '10:00', 'Miercoles'),
(12, 'Danza Contemporánea', 'Baile contemporáneo para ejercicio', 22, '17:00', '18:00', 'Miercoles'),
(13, 'Funcional Completo', 'Entrenamiento funcional completo', 16, '18:00', '19:00', 'Miercoles'),
(14, 'Stretching Profundo', 'Estiramientos profundos', 20, '19:00', '20:00', 'Miercoles'),
(5, 'Boxeo Técnico', 'Enfoque en técnica de boxeo', 12, '07:00', '08:00', 'Jueves'),
(6, 'Zumba Gold', 'Zumba para adultos mayores', 25, '08:00', '09:00', 'Jueves'),
(15, 'Calistenia Básica', 'Ejercicios con peso corporal', 18, '09:00', '10:00', 'Jueves'),
(16, 'HIIT Quema Grasa', 'High Intensity Interval Training', 20, '17:00', '18:00', 'Jueves'),
(17, 'Powerlifting', 'Levantamiento de potencia', 8, '18:00', '19:00', 'Jueves'),
(18, 'Cardio Blast', 'Sesión intensa de cardio', 25, '19:00', '20:00', 'Jueves'),
(1, 'CrossFit Open', 'Clase abierta de CrossFit', 15, '07:00', '08:00', 'Viernes');

INSERT INTO Grupo_de_Clase (horario, capacidad, id_clase) VALUES
('Lunes 07:00-08:00', 15, 1),
('Lunes 08:00-09:00', 20, 2),
('Lunes 09:00-10:00', 25, 3),
('Lunes 10:00-11:00', 18, 4),
('Lunes 17:00-18:00', 12, 5),
('Lunes 18:00-19:00', 30, 6),
('Martes 07:00-08:00', 12, 7),
('Martes 08:00-09:00', 20, 8),
('Martes 09:00-10:00', 15, 9),
('Martes 17:00-18:00', 16, 10),
('Martes 18:00-19:00', 10, 11),
('Martes 19:00-20:00', 25, 12),
('Miercoles 07:00-08:00', 20, 13),
('Miercoles 08:00-09:00', 18, 14),
('Miercoles 09:00-10:00', 14, 15),
('Miercoles 17:00-18:00', 22, 16),
('Miercoles 18:00-19:00', 16, 17),
('Miercoles 19:00-20:00', 20, 18),
('Jueves 07:00-08:00', 12, 19),
('Jueves 08:00-09:00', 25, 20),
('Jueves 09:00-10:00', 18, 21),
('Jueves 17:00-18:00', 20, 22),
('Jueves 18:00-19:00', 8, 23),
('Jueves 19:00-20:00', 25, 24),
('Viernes 07:00-08:00', 15, 25);

INSERT INTO Reserva (id_socio, id_grupo_de_clase, Estado_Reserva) VALUES
(1, 1, 'Activa'),
(2, 1, 'Activa'),
(3, 2, 'Activa'),
(4, 3, 'Cancelada'),
(5, 4, 'Activa'),
(6, 5, 'Completada'),
(7, 6, 'Activa'),
(8, 7, 'Activa'),
(9, 8, 'Cancelada'),
(10, 9, 'Activa'),
(11, 10, 'Activa'),
(12, 11, 'Completada'),
(13, 12, 'Activa'),
(14, 13, 'Activa'),
(15, 14, 'Cancelada'),
(16, 15, 'Activa'),
(17, 16, 'Activa'),
(18, 17, 'Completada'),
(19, 18, 'Activa'),
(20, 19, 'Activa'),
(21, 20, 'Cancelada'),
(22, 21, 'Activa'),
(23, 22, 'Activa'),
(24, 23, 'Completada'),
(25, 24, 'Activa');

INSERT INTO Pago (id_socio, id_grupo_de_clase, id_entrenador, Tipo_Pago, Metodo_Pago) VALUES
(1, 1, NULL, 'Mensual', 'Tarjeta'),
(2, NULL, 1, 'Clase', 'Efectivo'),
(3, 2, NULL, 'Mensual', 'Transferencia'),
(4, NULL, 2, 'Clase', 'Tarjeta'),
(5, 3, NULL, 'Mensual', 'Efectivo'),
(6, NULL, 3, 'Clase', 'Transferencia'),
(7, 4, NULL, 'Mensual', 'Tarjeta'),
(8, NULL, 4, 'Clase', 'Efectivo'),
(9, 5, NULL, 'Mensual', 'Transferencia'),
(10, NULL, 5, 'Clase', 'Tarjeta'),
(11, 6, NULL, 'Mensual', 'Efectivo'),
(12, NULL, 6, 'Clase', 'Transferencia'),
(13, 7, NULL, 'Mensual', 'Tarjeta'),
(14, NULL, 7, 'Clase', 'Efectivo'),
(15, 8, NULL, 'Mensual', 'Transferencia'),
(16, NULL, 8, 'Clase', 'Tarjeta'),
(17, 9, NULL, 'Mensual', 'Efectivo'),
(18, NULL, 9, 'Clase', 'Transferencia'),
(19, 10, NULL, 'Mensual', 'Tarjeta'),
(20, NULL, 10, 'Clase', 'Efectivo'),
(21, 11, NULL, 'Mensual', 'Transferencia'),
(22, NULL, 11, 'Clase', 'Tarjeta'),
(23, 12, NULL, 'Mensual', 'Efectivo'),
(24, NULL, 12, 'Clase', 'Transferencia'),
(25, 13, NULL, 'Mensual', 'Tarjeta');


