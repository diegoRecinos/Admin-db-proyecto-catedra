USE master;
sp_configure 'contained database authentication',1;

CREATE DATABASE GIMNASIO_DB containment = partial;

USE GIMNASIO_DB;

CREATE TABLE SOCIO (
	id INT IDENTITY (1,1) PRIMARY KEY,
	nombre NVARCHAR(100) NOT NULL,
	telefono NVARCHAR (20),
	correo NVARCHAR(100) UNIQUE CHECK (
		correo LIKE '_%@_%._%'
	)
);

CREATE TABLE CLASE(
	id INT IDENTITY(1,1) PRIMARY KEY,
	id_entrenador INT NOT NULL,
	valor_de_clase DECIMAL(10,2),
	mensualidad DECIMAL(10,2)
);

CREATE TABLE ENTRENADOR (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    correo NVARCHAR(100),
    especialidad NVARCHAR(100),
    sueldo DECIMAL(10,2)  
);

CREATE TABLE GRUPO_DE_CLASE (
    id INT IDENTITY(1,1) PRIMARY KEY,
    horario NVARCHAR(100),
    capacidad INT,
	id_clase INT
);

CREATE TABLE RESERVA (
  id INT IDENTITY(1,1) PRIMARY KEY,
  id_socio INT NOT NULL,
  id_grupo_de_clase INT NOT NULL
);

CREATE TABLE PAGO (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_socio INT NOT NULL,
    id_grupo_de_clase INT NULL,        
    id_entrenador INT NULL,     
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago NVARCHAR(50) NULL,
    fecha_y_hora DATETIME DEFAULT GETDATE()
);
GO


ALTER TABLE RESERVA
ADD CONSTRAINT FK_RESERVA_SOCIO
FOREIGN KEY (id_socio)
REFERENCES SOCIO(id);

ALTER TABLE RESERVA
ADD CONSTRAINT FK_RESERVA_GRUPODECLASE
FOREIGN KEY (id_grupo_de_clase)
REFERENCES GRUPO_DE_CLASE(id);

ALTER TABLE PAGO
ADD CONSTRAINT FK_PAGO_GRUPODECLASE
FOREIGN KEY (id_grupo_de_clase)
REFERENCES GRUPO_DE_CLASE (id);

ALTER TABLE PAGO
ADD CONSTRAINT FK_PAGO_ENTRENADOR
FOREIGN KEY (id_entrenador)
REFERENCES ENTRENADOR(id);

ALTER TABLE PAGO
ADD CONSTRAINT FK_PAGO_SOCIO
FOREIGN KEY (id_socio)
REFERENCES SOCIO(id)


ALTER TABLE CLASE
ADD CONSTRAINT FK_CLASE_ENTRENADOR
FOREIGN KEY (id_entrenador)
REFERENCES ENTRENADOR(id);

ALTER TABLE GRUPO_DE_CLASE
ADD CONSTRAINT FK_GRUPODECLASE_CLASE
FOREIGN KEY (id_clase)
REFERENCES CLASE(id)

--Datos quemados:
INSERT INTO SOCIO (nombre, telefono, correo) VALUES
('Ana García López', '555-1001', 'ana.garcia@email.com'),
('Carlos Rodríguez Santos', '555-1002', 'carlos.rodriguez@email.com'),
('María Hernández Díaz', '555-1003', 'maria.hernandez@email.com'),
('Javier Martínez Ruiz', '555-1004', 'javier.martinez@email.com'),
('Laura González Pérez', '555-1005', 'laura.gonzalez@email.com'),
('Miguel Sánchez Castro', '555-1006', 'miguel.sanchez@email.com'),
('Isabel Torres Mendoza', '555-1007', 'isabel.torres@email.com'),
('Roberto Vargas Rojas', '555-1008', 'roberto.vargas@email.com'),
('Carmen Silva Ortega', '555-1009', 'carmen.silva@email.com'),
('David Morales Herrera', '555-1010', 'david.morales@email.com'),
('Sofia Navarro Jiménez', '555-1011', 'sofia.navarro@email.com'),
('Alejandro Romero Flores', '555-1012', 'alejandro.romero@email.com'),
('Patricia Cruz Vega', '555-1013', 'patricia.cruz@email.com'),
('Fernando Reyes Paredes', '555-1014', 'fernando.reyes@email.com'),
('Elena Medina Soto', '555-1015', 'elena.medina@email.com'),
('José Luis Guerrero Campos', '555-1016', 'josel.guerrero@email.com'),
('Adriana Ríos Delgado', '555-1017', 'adriana.rios@email.com'),
('Ricardo Peña Mora', '555-1018', 'ricardo.pena@email.com'),
('Gabriela Cortés Núñez', '555-1019', 'gabriela.cortes@email.com'),
('Manuel Aguilar Salazar', '555-1020', 'manuel.aguilar@email.com'),
('Daniela Ponce León', '555-1021', 'daniela.ponce@email.com'),
('Sergio Montes Cervantes', '555-1022', 'sergio.montes@email.com'),
('Lucía Valencia Cordero', '555-1023', 'lucia.valencia@email.com'),
('Arturo Meza Guzmán', '555-1024', 'arturo.meza@email.com'),
('Verónica Ortiz Ramírez', '555-1025', 'veronica.ortiz@email.com');

INSERT INTO ENTRENADOR (nombre, correo, especialidad, sueldo) VALUES
('Carlos Mendoza', 'carlos.mendoza@gimnasio.com', 'CrossFit', 25000.00),
('Sofia Rojas', 'sofia.rojas@gimnasio.com', 'Yoga', 22000.00),
('Andrés Castillo', 'andres.castillo@gimnasio.com', 'Boxeo', 28000.00),
('Valeria Paredes', 'valeria.paredes@gimnasio.com', 'Pilates', 23000.00),
('Roberto Núñez', 'roberto.nunez@gimnasio.com', 'Spinning', 24000.00),
('Daniela Mejía', 'daniela.mejia@gimnasio.com', 'Zumba', 21000.00),
('Luis Fernández', 'luis.fernandez@gimnasio.com', 'Musculación', 26000.00),
('Camila Ortega', 'camila.ortez@gimnasio.com', 'Aeróbicos', 22500.00),
('Jorge Medina', 'jorge.medina@gimnasio.com', 'Artes Marciales', 27000.00),
('Natalia Vega', 'natalia.vega@gimnasio.com', 'TRX', 24500.00),
('Raúl Soto', 'raul.soto@gimnasio.com', 'Funcional', 25500.00),
('Andrea Cruz', 'andrea.cruz@gimnasio.com', 'Danza', 21500.00),
('Mario León', 'mario.leon@gimnasio.com', 'Calistenia', 26500.00),
('Gabriela Mora', 'gabriela.mora@gimnasio.com', 'Yoga Avanzado', 23500.00),
('Héctor Reyes', 'hector.reyes@gimnasio.com', 'Powerlifting', 29000.00),
('Paola Cervantes', 'paola.cervantes@gimnasio.com', 'Pilates Reformer', 24000.00),
('Sergio Guzmán', 'sergio.guzman@gimnasio.com', 'CrossFit Avanzado', 27500.00),
('Elena Montes', 'elena.montes@gimnasio.com', 'Yoga Terapéutico', 22800.00),
('Alberto Ríos', 'alberto.rios@gimnasio.com', 'Boxeo Olímpico', 28500.00),
('Verónica Salas', 'veronica.salas@gimnasio.com', 'Spinning Interválico', 25000.00),
('Óscar Delgado', 'oscar.delgado@gimnasio.com', 'Musculación Avanzada', 30000.00),
('Diana Ponce', 'diana.ponce@gimnasio.com', 'Zumba Gold', 21800.00),
('Felipe Cordero', 'felipe.cordero@gimnasio.com', 'Funcional Intenso', 26000.00),
('Jimena Valencia', 'jimena.valencia@gimnasio.com', 'Pilates Mat', 23200.00),
('Ricardo Peña', 'ricardo.pena@gimnasio.com', 'TRX Suspension', 24800.00);

INSERT INTO CLASE (id_entrenador, valor_de_clase, mensualidad) VALUES
(1, 350.00, 1200.00), (2, 300.00, 1000.00), (3, 400.00, 1500.00), (4, 320.00, 1100.00),
(5, 380.00, 1300.00), (6, 280.00, 900.00), (7, 450.00, 1600.00), (8, 310.00, 1050.00),
(9, 420.00, 1450.00), (10, 370.00, 1250.00), (11, 390.00, 1350.00), (12, 290.00, 950.00),
(13, 430.00, 1550.00), (14, 340.00, 1150.00), (15, 470.00, 1700.00), (16, 330.00, 1080.00),
(17, 410.00, 1400.00), (18, 360.00, 1200.00), (19, 440.00, 1580.00), (20, 375.00, 1280.00),
(21, 460.00, 1650.00), (22, 305.00, 980.00), (23, 385.00, 1320.00), (24, 325.00, 1020.00),
(25, 395.00, 1380.00);

INSERT INTO GRUPO_DE_CLASE (horario, capacidad, id_clase) VALUES
('Lunes y Miércoles 08:00-09:00', 20, 1), ('Martes y Jueves 10:00-11:00', 15, 2),
('Lunes y Viernes 18:00-19:00', 25, 3), ('Martes y Sábado 07:00-08:00', 18, 4),
('Miércoles y Viernes 16:00-17:00', 20, 5), ('Lunes y Jueves 12:00-13:00', 22, 6),
('Martes y Viernes 19:00-20:00', 16, 7), ('Miércoles y Sábado 09:00-10:00', 24, 8),
('Jueves y Sábado 17:00-18:00', 19, 9), ('Lunes y Miércoles 14:00-15:00', 21, 10),
('Martes y Jueves 20:00-21:00', 17, 11), ('Viernes y Sábado 11:00-12:00', 23, 12),
('Lunes y Viernes 06:00-07:00', 20, 13), ('Martes y Sábado 15:00-16:00', 18, 14),
('Miércoles y Viernes 13:00-14:00', 25, 15), ('Lunes y Jueves 19:00-20:00', 15, 16),
('Martes y Viernes 08:00-09:00', 22, 17), ('Miércoles y Sábado 16:00-17:00', 19, 18),
('Jueves y Sábado 10:00-11:00', 16, 19), ('Lunes y Miércoles 17:00-18:00', 24, 20),
('Martes y Jueves 09:00-10:00', 21, 21), ('Viernes y Sábado 14:00-15:00', 17, 22),
('Lunes y Viernes 20:00-21:00', 23, 23), ('Martes y Sábado 12:00-13:00', 20, 24),
('Miércoles y Viernes 07:00-08:00', 18, 25);

INSERT INTO RESERVA (id_socio, id_grupo_de_clase) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25);

INSERT INTO PAGO (id_socio, id_grupo_de_clase, id_entrenador, monto, metodo_pago, fecha_y_hora) VALUES
(1, 1, 1, 1200.00, 'Tarjeta Crédito', '2024-01-05 08:30:00'),
(2, 2, 2, 1000.00, 'Efectivo', '2024-01-05 09:15:00'),
(3, 3, 3, 1500.00, 'Transferencia', '2024-01-05 10:00:00'),
(4, 4, 4, 1100.00, 'Tarjeta Débito', '2024-01-05 11:30:00'),
(5, 5, 5, 1300.00, 'Tarjeta Crédito', '2024-01-05 12:45:00'),
(6, 6, 6, 900.00, 'Efectivo', '2024-01-06 08:00:00'),
(7, 7, 7, 1600.00, 'Transferencia', '2024-01-06 09:30:00'),
(8, 8, 8, 1050.00, 'Tarjeta Débito', '2024-01-06 10:45:00'),
(9, 9, 9, 1450.00, 'Tarjeta Crédito', '2024-01-06 12:00:00'),
(10, 10, 10, 1250.00, 'Efectivo', '2024-01-06 13:15:00'),
(11, 11, 11, 1350.00, 'Transferencia', '2024-01-07 08:20:00'),
(12, 12, 12, 950.00, 'Tarjeta Débito', '2024-01-07 09:40:00'),
(13, 13, 13, 1550.00, 'Tarjeta Crédito', '2024-01-07 11:00:00'),
(14, 14, 14, 1150.00, 'Efectivo', '2024-01-07 12:20:00'),
(15, 15, 15, 1700.00, 'Transferencia', '2024-01-08 08:10:00'),
(16, 16, 16, 1080.00, 'Tarjeta Débito', '2024-01-08 09:50:00'),
(17, 17, 17, 1400.00, 'Tarjeta Crédito', '2024-01-08 11:15:00'),
(18, 18, 18, 1200.00, 'Efectivo', '2024-01-08 12:30:00'),
(19, 19, 19, 1580.00, 'Transferencia', '2024-01-09 08:40:00'),
(20, 20, 20, 1280.00, 'Tarjeta Débito', '2024-01-09 10:00:00'),
(21, 21, 21, 1650.00, 'Tarjeta Crédito', '2024-01-09 11:20:00'),
(22, 22, 22, 980.00, 'Efectivo', '2024-01-09 12:40:00'),
(23, 23, 23, 1320.00, 'Transferencia', '2024-01-10 08:25:00'),
(24, 24, 24, 1020.00, 'Tarjeta Débito', '2024-01-10 09:35:00'),
(25, 25, 25, 1380.00, 'Tarjeta Crédito', '2024-01-10 10:50:00');


