/*indices para busquedas comunes compuestos y simples*/

/*============SOCIO======== */ 
/*1 Buscar socios activos*/
SELECT * FROM Socio WHERE Estado = 'Activo';

CREATE NONCLUSTERED INDEX idx_socio_estado_activo ON Socio(Estado);

/*2 Buscar socio por email*/
SELECT * FROM Socio
WHERE Email = 'laura.torres@email.com';

CREATE UNIQUE INDEX idx_socio_email ON Socio(Email);

/*3 buscar socio por nombre y apellido*/
SELECT * FROM Socio 
WHERE Nombre = 'Laura' AND Apellido = 'Torres';

CREATE NONCLUSTERED INDEX idx_socio_nombre_apellido 
ON Socio(Nombre, Apellido);


/*===========PAGO============*/ 
/*1 Buscar pago por fecha*/
SELECT * FROM Pago 
WHERE Fecha_pago BETWEEN '2025-01-01' AND '2025-12-31';

CREATE NONCLUSTERED INDEX idx_pago_fechapago ON Pago(Fecha_Pago);

/*2 Buscar pago por socio id*/
SELECT * FROM Pago 
WHERE id_socio = 10;

CREATE NONCLUSTERED INDEX idx_pago_socio ON Pago(id_socio)

/*===========RESERVA=========*/
/* 1 Buscar reserva por fecha*/
SELECT * FROM Reserva 
WHERE Fecha_Reserva = '2025-11-12 21:02:22.690';

CREATE NONCLUSTERED INDEX idx_reserva_fecha ON Reserva(fecha_reserva);

/*2 Buscar reserva por socio_id*/
SELECT * FROM Socio
WHERE Socio.Id = 1;

CREATE NONCLUSTERED INDEX idx_reserva_socio ON Reserva(id_socio);

/*3 Buscar reserva por id_grupo clase*/
SELECT * FROM Reserva
WHERE Reserva.id_grupo_de_clase = 1;

CREATE NONCLUSTERED INDEX idx_reserva_grupo ON Reserva(id_grupo_de_clase);

/*4 Historial de reservas por socio, ordenadas por fecha.*/
SELECT * FROM Reserva
WHERE id_socio = 10
ORDER BY Fecha_Reserva DESC;

CREATE NONCLUSTERED INDEX idx_reserva_socio_fecha
ON Reserva(id_socio, Fecha_Reserva);

/*=============CLASE==================*/
/* 1 Filtrar clases por día y ordenarlas.*/
SELECT * FROM Clase
WHERE Dia_Semana = 'Lunes'
ORDER BY Hora_Inicio;

CREATE NONCLUSTERED INDEX idx_clase_dia_hora
ON Clase(Dia_Semana, Hora_Inicio);

/*============GRUPO DE CLASE=========*/
/*1 Buscar grupos por clase y ordenar por horario*/
SELECT * FROM Grupo_de_Clase 
WHERE id_clase = 3
ORDER BY horario;

CREATE NONCLUSTERED INDEX idx_grupo_clase_horario
ON Grupo_de_Clase(id_clase, horario);



/*-----INDICES PARA JOINS COMUNES------*/
/*indices para relaciones entre tablas FK*/

/* ======== RESERVA ======== */
/* FK → Socio */
CREATE NONCLUSTERED INDEX idx_reserva_socio ON Reserva(id_socio);

/* FK → Grupo_de_Clase */
CREATE NONCLUSTERED INDEX idx_reserva_grupo ON Reserva(id_grupo_de_clase);

/* ======== PAGO ======== */
/* FK a Socio */
CREATE NONCLUSTERED INDEX idx_pago_socio ON Pago(id_socio);

/* FK a Grupo_de_Clase */
CREATE NONCLUSTERED INDEX idx_pago_grupo ON Pago(id_grupo_de_clase);

/* FK a Entrenador */
CREATE NONCLUSTERED INDEX idx_pago_entrenador ON Pago(id_entrenador);

/* ======== GRUPO DE CLASE ======== */
/* FK a Clase */
CREATE NONCLUSTERED INDEX idx_grupoclase_clase ON Grupo_de_Clase(id_clase);

/* ======== CLASE ======== */
/* FK a Entrenador */
CREATE NONCLUSTERED INDEX idx_clase_entrenador ON Clase(Id_Entrenador);

/*Para JOINS como*/

/* inf de socio*/
SELECT Reserva.Id, Socio.Nombre, Socio.Apellido, Grupo_de_Clase.horario, Clase.Nombre AS Clase
FROM Reserva 
JOIN Socio  ON Socio.Id = Reserva.id_socio
JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Reserva.id_grupo_de_clase
JOIN Clase ON Clase.Id = Grupo_de_Clase.id_clase
WHERE Socio.Id = 10;

/*Pagos de un socio con info de grupo y clase*/
SELECT Pago.Monto, Pago.Fecha_Pago, Clase.Nombre AS Clase, Entrenador.Nombre AS Entrenador
FROM Pago 
LEFT JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Pago.id_grupo_de_clase
LEFT JOIN Clase  ON Clase.Id = Grupo_de_Clase.id_clase
LEFT JOIN Entrenador ON Entrenador.Id = Pago.id_entrenador
WHERE Pago.id_socio = 10;

/*Reservas con datos del socio y clase*/
SELECT Reserva.Id, Socio.Nombre, Socio.Apellido, Grupo_de_Clase.horario, Clase.Nombre AS Clase
FROM Reserva 
JOIN Socio  ON Socio.Id = Reserva.id_socio
JOIN Grupo_de_Clase  ON Grupo_de_Clase.Id = Reserva.id_grupo_de_clase
JOIN Clase  ON Clase.Id = Grupo_de_Clase.id_clase
WHERE Socio.Id = 10;

/*Clases con el nombre del entrenador*/
SELECT Clase.Nombre, Clase.Dia_Semana, Entrenador.Nombre AS Entrenador
FROM Clase
JOIN Entrenador  ON Entrenador.Id = Clase.Id_Entrenador
ORDER BY Clase.Dia_Semana, Clase.Hora_Inicio;