SET STATISTICS IO ON;
SET STATISTICS TIME ON;
USE GIMNASIO_DB;

/*Indices para busquedas comunes compuestos y simples*/

/*===========SOCIO======== */ 
/*1 Buscar socios activos VISTA VW_Dashboard_Gimnasio, VW_Socios_Morosos */
SELECT * FROM VW_Dashboard_Gimnasio;
SELECT * FROM VW_Socios_Morosos;
SELECT * FROM Socio WHERE Estado = 'Activo';

CREATE NONCLUSTERED INDEX idx_socio_estado_activo ON Socio(Estado);

/*2 Buscar socio por email*/
SELECT * FROM Socio
WHERE Email = 'laura.torres008@email.com';

CREATE UNIQUE INDEX idx_socio_email ON Socio(Email);

/*3 Buscar socio por nombre y apellido*/
SELECT * FROM Socio 
WHERE Nombre = 'Laura' AND Apellido = 'Torres';

CREATE NONCLUSTERED INDEX idx_socio_nombre_apellido 
ON Socio(Nombre, Apellido);


/*===========PAGO============*/ 
/*1 Buscar pago por fecha VISTA VW_Dashboard_Gimnasio*/
SELECT * FROM VW_Dashboard_Gimnasio;
SELECT * FROM Pago 
WHERE Fecha_pago BETWEEN '2025-01-01' AND '2025-12-31';

CREATE NONCLUSTERED INDEX idx_pago_fechapago 
ON Pago(Fecha_Pago)
INCLUDE (Monto);

/*2. VISTA VW_Socios_Morosos FK */
SELECT * FROM VW_Socios_Morosos;

CREATE NONCLUSTERED INDEX idx_pago_socio_fecha
ON Pago(id_socio, Fecha_Pago);


/*===========RESERVA=========*/
/* 1 Buscar reserva por fecha*/
SELECT * FROM Reserva 
WHERE Fecha_Reserva = '2025-01-28 16:45:00';

CREATE NONCLUSTERED INDEX idx_reserva_fecha ON Reserva(fecha_reserva);

/*2 Buscar reserva por id_grupo clase VISTA VW_Clases_Disponibilidad, VW_Horario_Semanal (FK)*/
SELECT * FROM VW_Horario_Semanal;
SELECT * FROM Reserva
WHERE id_grupo_de_clase = 12;

CREATE NONCLUSTERED INDEX idx_reserva_grupo ON Reserva(id_grupo_de_clase);

/*3 Historial de reservas por socio, ordenadas por fecha. (FK)*/
SELECT * FROM Reserva
WHERE id_socio = 12
ORDER BY Fecha_Reserva DESC;

CREATE NONCLUSTERED INDEX idx_reserva_socio_fecha
ON Reserva(id_socio, Fecha_Reserva);

/*4. VW_Clases_Disponibilidad. */
SELECT * FROM VW_Clases_Disponibilidad 
WHERE Estado = 'DISPONIBLE';

CREATE NONCLUSTERED INDEX idx_reserva_estado_grupo
ON Reserva(Estado_Reserva, id_grupo_de_clase)
INCLUDE (Id);


/*=============CLASE==================*/
/* 1 Filtrar clases por día y ordenarlas. VW_Clases_Disponibilidad, VW_Horario_Semanal*/
SELECT * FROM VW_Clases_Disponibilidad;
SELECT * FROM Clase
WHERE Dia_Semana = 'Lunes'
ORDER BY Hora_Inicio;

CREATE NONCLUSTERED INDEX idx_clase_dia_hora
ON Clase(Dia_Semana, Hora_Inicio);


/*============GRUPO DE CLASE=========*/
/*1 Buscar grupos por clase y ordenar por horario (FK)*/
SELECT * FROM Grupo_de_Clase 
WHERE id_clase = 3
ORDER BY horario;

CREATE NONCLUSTERED INDEX idx_grupo_clase_horario
ON Grupo_de_Clase(id_clase, horario);


/*-----INDICES PARA JOINS COMUNES------*/
/*indices faltantes para relaciones entre tablas (FK)*/

/* ======== PAGO ======== */
/* FK → Grupo_de_Clase */
CREATE NONCLUSTERED INDEX idx_pago_grupo ON Pago(id_grupo_de_clase);

/* FK → Entrenador */
CREATE NONCLUSTERED INDEX idx_pago_entrenador ON Pago(id_entrenador);


/* ======== CLASE ======== */
/* FK a Entrenador */
CREATE NONCLUSTERED INDEX idx_clase_entrenador ON Clase(Id_Entrenador);


/*Para JOINS como*/

/*1. Informacion de socio*/
SELECT Reserva.Id, Socio.Nombre, Socio.Apellido, Grupo_de_Clase.horario, Clase.Nombre AS Clase
FROM Reserva 
JOIN Socio  ON Socio.Id = Reserva.id_socio
JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Reserva.id_grupo_de_clase
JOIN Clase ON Clase.Id = Grupo_de_Clase.id_clase
WHERE Socio.Id = 12;

/*2. Pagos de un socio con info de grupo y clase*/
SELECT Pago.Monto, Pago.Fecha_Pago, Clase.Nombre AS Clase, Entrenador.Nombre AS Entrenador
FROM Pago 
LEFT JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Pago.id_grupo_de_clase
LEFT JOIN Clase  ON Clase.Id = Grupo_de_Clase.id_clase
LEFT JOIN Entrenador ON Entrenador.Id = Pago.id_entrenador
WHERE Pago.id_socio = 10;

/*3. Reservas con datos del socio y clase*/
SELECT Reserva.Id, Reserva.Fecha_Reserva , Socio.Nombre, Socio.Apellido, Grupo_de_Clase.horario, Clase.Nombre AS Clase
FROM Reserva 
JOIN Socio  ON Socio.Id = Reserva.id_socio
JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Reserva.id_grupo_de_clase
JOIN Clase  ON Clase.Id = Grupo_de_Clase.id_clase
WHERE Socio.Id = 12;

-- En SQL Server: índices que el optimizador sugiere
SELECT * FROM sys.dm_db_missing_index_details

-- Consultar la fragmentación y consulta para SQL server job agent 
SELECT 
OBJECT_NAME(ips.object_id) AS Tabla,
i.name AS Indice,
ips.index_type_desc AS Tipo,
ips.avg_fragmentation_in_percent AS Fragmentacion
FROM
sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN
sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE
ips.database_id = DB_ID();

/*--REBUILD O REORGANIZE--*/
/*SOCIO*/
ALTER INDEX idx_socio_estado_activo ON Socio REBUILD;
ALTER INDEX idx_socio_email ON Socio REBUILD;
ALTER INDEX idx_socio_nombre_apellido ON Socio REBUILD;

/*PAGO*/
ALTER INDEX idx_pago_fechapago ON Pago REBUILD;
ALTER INDEX idx_pago_socio_fecha ON Pago REBUILD;
ALTER INDEX idx_pago_grupo ON Pago REBUILD;
ALTER INDEX idx_pago_entrenador ON Pago REBUILD;

/*RESERVA*/
ALTER INDEX idx_reserva_fecha ON Reserva REBUILD;
ALTER INDEX idx_reserva_grupo ON Reserva REBUILD;
ALTER INDEX idx_reserva_socio_fecha ON Reserva REBUILD;
ALTER INDEX idx_reserva_estado_grupo ON Reserva REBUILD;

/*CLASE*/
ALTER INDEX idx_clase_dia_hora ON Clase REBUILD;
ALTER INDEX idx_clase_entrenador ON Clase REBUILD;

/*GRUPO_DE_CLASE*/
ALTER INDEX idx_grupo_clase_horario ON Grupo_de_Clase REBUILD;
