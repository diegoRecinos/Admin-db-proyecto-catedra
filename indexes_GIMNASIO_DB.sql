/*indices para busquedas comunes (WHERE)*/
/*Buscar socios activos*/
SELECT * FROM Socio WHERE Estado = 'Activo';
CREATE NONCLUSTERED INDEX IX_Socio_estado_activos ON Socio(Estado);


SELECT * FROM Pago WHERE Fecha_pago BETWEEN '2025-01-01' AND '2025-12-31';
CREATE NONCLUSTERED INDEX IX_pago_fechapago ON Pago(Fecha_Pago);


SELECT *
FROM Socio
WHERE Email = 'laura.torres@email.com';
CREATE UNIQUE INDEX idx_socio_email ON Socio(Email);


/*indices para las relaciones de tablas y foreign keys para mejorar joins */
CREATE INDEX IX_Reserva_Socio ON Reserva(id_socio);
CREATE INDEX IX_Reserva_Grupodeclase ON Reserva(id_grupo_de_clase);
CREATE INDEX IX_Pago_Socio ON Pago(id_socio);
CREATE INDEX IX_Pago_Entrenador ON Pago(id_entrenador);
CREATE INDEX IX_Pago_Grupodeclase ON Pago(id_grupo_de_clase);
CREATE INDEX IX_Clase_Entrenador ON Clase(Id_Entrenador);
CREATE INDEX IX_Grupodeclase_Clase ON Grupo_de_Clase(id_clase);