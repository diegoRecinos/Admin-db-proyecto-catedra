USE GIMNASIO_DB;
GO
--Vistas para ver el dashboard principal:
CREATE VIEW VW_Dashboard_Gimnasio AS 
WITH ClasePopular AS (
    SELECT TOP 1 c.Nombre, COUNT(r.Id) as Total
    FROM Clase c
    INNER JOIN Grupo_de_Clase gc ON c.Id = gc.id_clase 
    INNER JOIN Reserva r ON gc.Id = r.id_grupo_de_clase
    WHERE r.Estado_Reserva = 'Activa'
    GROUP BY c.Id, c.Nombre 
    ORDER BY COUNT(r.Id) DESC
),
EntrenadorActivo AS (
    SELECT TOP 1 e.Nombre, COUNT(c.Id) as Total
    FROM Entrenador e
    INNER JOIN Clase c ON e.Id = c.Id_Entrenador
    GROUP BY e.Id, e.Nombre
    ORDER BY COUNT(c.Id) DESC
)
SELECT
    (SELECT COUNT(*) FROM Socio WHERE Estado = 'Activo') AS Socios_Activos,
    (SELECT COUNT(*) FROM Entrenador) AS Total_Entrenadores,
    (SELECT COUNT(*) FROM Clase) AS Clases_Activas,
    (SELECT SUM(Monto) FROM Pago WHERE MONTH(Fecha_Pago) = MONTH(GETDATE())) AS Ingresos_Actuales_Mes,
    (SELECT Nombre FROM ClasePopular) AS Clase_Mas_Concurrida,
    (SELECT Nombre FROM EntrenadorActivo) AS Entrenador_Mas_Activo;
GO

--Vista para ver las clases disponibles
CREATE VIEW VW_Clases_Disponibilidad AS
SELECT 
    c.Id,
    c.Nombre AS Clase,
    e.Nombre AS Entrenador,
    c.Dia_Semana,
    c.Hora_Inicio,
    c.Hora_Fin,
    c.Capacidad,
    COUNT(CASE WHEN r.Estado_Reserva = 'Activa' THEN 1 END) AS Inscritos,
    c.Capacidad - COUNT(CASE WHEN r.Estado_Reserva = 'Activa' THEN 1 END) AS Cupos_Disponibles,
    CASE 
        WHEN COUNT(CASE WHEN r.Estado_Reserva = 'Activa' THEN 1 END) = c.Capacidad THEN 'LLENA'
        ELSE 'DISPONIBLE'
    END AS Estado
FROM Clase c
INNER JOIN Entrenador e ON c.Id_Entrenador = e.Id
INNER JOIN Grupo_de_Clase gc ON c.Id = gc.id_clase
LEFT JOIN Reserva r ON gc.Id = r.id_grupo_de_clase
GROUP BY c.Id, c.Nombre, e.Nombre, c.Dia_Semana, c.Hora_Inicio, c.Hora_Fin, c.Capacidad;
GO

--Ver a los socios morosos
CREATE VIEW VW_Socios_Morosos AS
SELECT 
    s.Id,
    s.Nombre,
    s.Apellido,
    s.Email,
    MAX(p.Fecha_Pago) AS Ultimo_Pago,
    DATEDIFF(DAY, MAX(p.Fecha_Pago), GETDATE()) AS Dias_Sin_Pagar,
    CASE 
        WHEN MAX(p.Fecha_Pago) IS NULL THEN 'SIN PAGOS'
        WHEN DATEDIFF(DAY, MAX(p.Fecha_Pago), GETDATE()) > 30 THEN 'MOROSO'
        ELSE 'AL DÍA'
    END AS Estado
FROM Socio s
LEFT JOIN Pago p ON s.Id = p.id_socio
WHERE s.Estado = 'Activo'
GROUP BY s.Id, s.Nombre, s.Apellido, s.Email
HAVING MAX(p.Fecha_Pago) IS NULL OR DATEDIFF(DAY, MAX(p.Fecha_Pago), GETDATE()) > 30;
GO

--Horarios semanales :D
CREATE VIEW VW_Horario_Semanal AS
SELECT 
    c.Dia_Semana,
    c.Nombre AS Clase,
    e.Nombre AS Entrenador,
    c.Hora_Inicio,
    c.Hora_Fin,
    c.Capacidad,
    COUNT(CASE WHEN r.Estado_Reserva = 'Activa' THEN 1 END) AS Inscritos
FROM Clase c
INNER JOIN Entrenador e ON c.Id_Entrenador = e.Id
INNER JOIN Grupo_de_Clase gc ON c.Id = gc.id_clase
LEFT JOIN Reserva r ON gc.Id = r.id_grupo_de_clase
GROUP BY c.Dia_Semana, c.Nombre, e.Nombre, c.Hora_Inicio, c.Hora_Fin, c.Capacidad;
GO

--Consulta de vistas:
SELECT * FROM VW_Dashboard_Gimnasio;

SELECT * FROM VW_Clases_Disponibilidad;

SELECT * FROM VW_Clases_Disponibilidad 
WHERE Estado = 'DISPONIBLE';

SELECT * FROM VW_Clases_Disponibilidad 
WHERE Dia_Semana = 'Lunes'
ORDER BY Hora_Inicio;

SELECT * FROM VW_Clases_Disponibilidad 
WHERE Inscritos >= Capacidad * 0.8;

SELECT * FROM VW_Socios_Morosos;

SELECT * FROM VW_Socios_Morosos 
ORDER BY Dias_Sin_Pagar DESC;

SELECT Estado, COUNT(*) as Cantidad
FROM VW_Socios_Morosos 
GROUP BY Estado;

SELECT * FROM VW_Horario_Semanal 
ORDER BY 
    CASE Dia_Semana
        WHEN 'Lunes' THEN 1
        WHEN 'Martes' THEN 2
        WHEN 'Miercoles' THEN 3
        WHEN 'Jueves' THEN 4
        WHEN 'Viernes' THEN 5
        WHEN 'Sabado' THEN 6
        WHEN 'Domingo' THEN 7
    END,
    Hora_Inicio;

SELECT * FROM VW_Horario_Semanal 
WHERE Dia_Semana = 'Viernes'
ORDER BY Hora_Inicio;

SELECT * FROM VW_Horario_Semanal 
WHERE Entrenador LIKE '%Carlos%';