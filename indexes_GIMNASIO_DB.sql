/*indices para busquedas comunes*/

/*============SOCIO======== */ 
/*Buscar socios activos*/
SELECT * FROM Socio WHERE Estado = 'Activo';

CREATE NONCLUSTERED INDEX idx_socio_estado_activo ON Socio(Estado);

/*Buscar socio por email*/
SELECT * FROM Socio
WHERE Email = 'laura.torres@email.com';

CREATE UNIQUE INDEX idx_socio_email ON Socio(Email);

/*buscar socia por nombre y apellido*/
SELECT * FROM Socio 
WHERE Nombre = 'Laura' AND Apellido = 'Torres';

CREATE NONCLUSTERED INDEX idx_socio_nombre_apellido 
ON Socio(Nombre, Apellido);


/*===========PAGO============*/ 
/* Buscar pago por fecha*/
SELECT * FROM Pago 
WHERE Fecha_pago BETWEEN '2025-01-01' AND '2025-12-31';

CREATE NONCLUSTERED INDEX idx_pago_fechapago ON Pago(Fecha_Pago);

/*Buscar pago por socio id*/
SELECT * FROM Pago 
WHERE id_socio = 10;

CREATE NONCLUSTERED INDEX idx_pago_socio ON Pago(id_socio)

/*===========RESERVA=========*/
/*Buscar reserva por fecha*/
SELECT * FROM Reserva 
WHERE Fecha_Reserva = '2025-11-12 21:02:22.690';

CREATE NONCLUSTERED INDEX idx_reserva_fecha ON Reserva(fecha_reserva);

/*Buscar reserva por socio_id*/
SELECT * FROM Socio
WHERE Socio.Id = 1;

CREATE NONCLUSTERED INDEX idx_reserva_socio ON Reserva(id_socio);

/*Buscar reserva por id_grupo clase*/
SELECT * FROM Reserva
WHERE Reserva.id_grupo_de_clase = 1;

CREATE NONCLUSTERED INDEX idx_reserva_grupo ON Reserva(id_grupo_de_clase);

/*============GRUPO DE CLASE=========*/
/*Buscar grupos por clase y ordenar por horario*/
SELECT * FROM Grupo_de_Clase 
WHERE id_clase = 3
ORDER BY horario;

CREATE NONCLUSTERED INDEX idx_grupo_clase_horario
ON Grupo_de_Clase(id_clase, horario);

