/*indices para busquedas comunes*/

/*SOCIO */ 
/*Buscar socios activos*/
SELECT * FROM Socio WHERE Estado = 'Activo';
CREATE NONCLUSTERED INDEX idx_socio_estado_activo ON Socio(Estado);

/*Buscar socio por email*/
SELECT * FROM Socio
WHERE Email = 'laura.torres@email.com';

CREATE UNIQUE INDEX idx_socio_email ON Socio(Email);

/*PAGO*/ 
/* Buscar pago por fecha*/
SELECT * FROM Pago WHERE Fecha_pago BETWEEN '2025-01-01' AND '2025-12-31';
CREATE NONCLUSTERED INDEX idx_pago_fechapago ON Pago(Fecha_Pago);

/*Buscar pago por socio id*/
CREATE NONCLUSTERED INDEX idx_pago_socio ON Pago(id_socio)

/*RESERVA*/
/*Buscar reserva por fecha*/
CREATE NONCLUSTERED INDEX idx_reserva_fecha ON Reserva(fecha_reserva);

/*Buscar reserva por socio_id*/
CREATE NONCLUSTERED INDEX idx_reserva_socio ON Reserva(id_socio);

/*Buscar reserva por id_grupo clase*/
CREATE NONCLUSTERED INDEX idx_reserva_grupo ON Reserva(id_grupo_de_clase);
