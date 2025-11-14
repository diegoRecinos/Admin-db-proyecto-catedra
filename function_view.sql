USE GIMNASIO_DB;


--Calcular el sueldo de un entrandor si el salario es fijo pero puede variar si hay personas que se inscriben
SELECT e.Id, e.Nombre, e.Especialidad, COUNT(r.id) AS Total_Alumnos,
    RANK() OVER (ORDER BY COUNT(r.id) DESC) AS Ranking_Popularidad,
    LAG(COUNT(r.id)) OVER (ORDER BY COUNT(r.id) DESC) AS Alumnos_Entrenador_Anterior,
    LEAD(COUNT(r.id)) OVER (ORDER BY COUNT(r.id) DESC) AS Alumnos_Entrenador_Siguiente
FROM Entrenador e INNER JOIN Clase c ON e.Id = c.Id_Entrenador
    INNER JOIN Grupo_de_Clase gc ON c.Id = gc.id_clase
    INNER JOIN Reserva r ON gc.Id = r.id_grupo_de_clase
WHERE r.Estado_Reserva = 'Activa'
GROUP BY e.Id, e.Nombre, e.Especialidad;

--Calcular cual es la ganancia total del gimacio
SELECT Fecha_Pago, Monto, SUM(Monto) OVER (ORDER BY Fecha_Pago ROWS UNBOUNDED PRECEDING) AS Ganancia_Acumulada,
    AVG(Monto) OVER (ORDER BY Fecha_Pago ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Promedio_Movil_7_Dias,
    LAG(Monto) OVER (ORDER BY Fecha_Pago) AS Pago_Dia_Anterior,
    CAST((Monto - LAG(Monto) OVER (ORDER BY Fecha_Pago)) * 100.0 / LAG(Monto) 
OVER (ORDER BY Fecha_Pago) AS DECIMAL(5,2)) AS Variacion_Porcentual
FROM Pago
ORDER BY Fecha_Pago;

--Calcular el ranking de los metodos de pago 
WITH
    PagosMensuales
    AS
    (
        SELECT
            YEAR(Fecha_Pago) AS Anio,
            MONTH(Fecha_Pago) AS Mes,
            Metodo_Pago,
            SUM(Monto) AS Total_Mensual,
            COUNT(*) AS Cantidad_Pagos
        FROM Pago
        GROUP BY YEAR(Fecha_Pago), MONTH(Fecha_Pago), Metodo_Pago
    )
SELECT
    *,
    RANK() OVER (PARTITION BY Anio, Mes ORDER BY Total_Mensual DESC) AS Ranking_Metodo_Pago,
    SUM(Total_Mensual) OVER (PARTITION BY Anio, Mes) AS Total_Mes,
    CAST(Total_Mensual * 100.0 / SUM(Total_Mensual) OVER (PARTITION BY Anio, Mes) AS DECIMAL(5,2)) AS Porcentaje_Mes
FROM PagosMensuales
ORDER BY Anio DESC, Mes DESC, Ranking_Metodo_Pago;

--Calcular y saber que socios han pagado en el mes actual y cuales no en un plazo de tiempo
SELECT 
    s.Id,
    s.Nombre + ' ' + s.Apellido AS Socio,
    p.Fecha_Pago,
    p.Monto,
    p.Tipo_Pago,
    LAG(p.Fecha_Pago) OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago) AS Ultimo_Pago_Anterior,
    DATEDIFF(DAY, LAG(p.Fecha_Pago) OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago), p.Fecha_Pago) AS Dias_Entre_Pagos,
    AVG(p.Monto) OVER (PARTITION BY s.Id) AS Promedio_Pago_Socio,
    COUNT(p.id) OVER (PARTITION BY s.Id) AS Total_Pagos_Socio,
    ROW_NUMBER() OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago DESC) AS Numero_Pago_Reciente
FROM Socio s
INNER JOIN Pago p ON s.Id = p.id_socio
WHERE s.Estado = 'Activo'
ORDER BY s.Id, p.Fecha_Pago DESC;

--Calculo de pago y de clientes con mora:
SELECT 
    s.Id,
    s.Nombre + ' ' + s.Apellido AS Socio,
    p.Fecha_Pago,
    p.Monto,
    p.Tipo_Pago,
    LAG(p.Fecha_Pago) OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago) AS Ultimo_Pago_Anterior,
    DATEDIFF(DAY, LAG(p.Fecha_Pago) OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago), p.Fecha_Pago) AS Dias_Entre_Pagos,
    AVG(p.Monto) OVER (PARTITION BY s.Id) AS Promedio_Pago_Socio,
    COUNT(p.id) OVER (PARTITION BY s.Id) AS Total_Pagos_Socio,
    ROW_NUMBER() OVER (PARTITION BY s.Id ORDER BY p.Fecha_Pago DESC) AS Numero_Pago_Reciente
FROM Socio s
INNER JOIN Pago p ON s.Id = p.id_socio
WHERE s.Estado = 'Activo'
ORDER BY s.Id, p.Fecha_Pago DESC;

WITH UltimoPago AS (
    SELECT 
        s.Id,
        s.Nombre + ' ' + s.Apellido AS Socio,
        s.Estado,
        MAX(p.Fecha_Pago) AS Ultima_Fecha_Pago,
        DATEDIFF(DAY, MAX(p.Fecha_Pago), GETDATE()) AS Dias_Sin_Pagar
    FROM Socio s
    LEFT JOIN Pago p ON s.Id = p.id_socio
    WHERE s.Estado = 'Activo'
    GROUP BY s.Id, s.Nombre, s.Apellido, s.Estado
)
SELECT 
    *,
    AVG(Dias_Sin_Pagar) OVER() AS Promedio_Dias_Sin_Pagar_General,
    CASE 
        WHEN Dias_Sin_Pagar > AVG(Dias_Sin_Pagar) OVER() THEN 'ARRIBA DEL PROMEDIO'
        WHEN Dias_Sin_Pagar < AVG(Dias_Sin_Pagar) OVER() THEN 'DEBAJO DEL PROMEDIO'
        ELSE 'EN EL PROMEDIO'
    END AS Comparacion_Promedio,
    PERCENT_RANK() OVER (ORDER BY Dias_Sin_Pagar) AS Percentil_Morosidad,
    NTILE(4) OVER (ORDER BY Dias_Sin_Pagar) AS Cuartil_Morosidad
FROM UltimoPago
ORDER BY Dias_Sin_Pagar DESC;

--Calcular la asistencia por semana:
SELECT 
    Dia_Semana,
    COUNT(*) AS Total_Clases,
    SUM(Asistentes) AS Total_Asistentes,
    AVG(Asistentes) AS Promedio_Asistentes,
    SUM(Asistentes) - LAG(SUM(Asistentes)) OVER (ORDER BY 
        CASE Dia_Semana
            WHEN 'Lunes' THEN 1
            WHEN 'Martes' THEN 2
            WHEN 'Miercoles' THEN 3
            WHEN 'Jueves' THEN 4
            WHEN 'Viernes' THEN 5
            WHEN 'Sabado' THEN 6
            WHEN 'Domingo' THEN 7
        END) AS Diferencia_Dia_Anterior,
    CAST(SUM(Asistentes) * 100.0 / SUM(SUM(Asistentes)) OVER() AS DECIMAL(5,2)) AS Porcentaje_Semanal
FROM (
    SELECT 
        c.Dia_Semana,
        COUNT(CASE WHEN r.Estado_Reserva IN ('Activa', 'Completada') THEN 1 END) AS Asistentes
    FROM Clase c
    INNER JOIN Grupo_de_Clase gc ON c.Id = gc.id_clase
    LEFT JOIN Reserva r ON gc.Id = r.id_grupo_de_clase
    GROUP BY c.Id, c.Dia_Semana
) AS ClasesDia
GROUP BY Dia_Semana
ORDER BY 
    CASE Dia_Semana
        WHEN 'Lunes' THEN 1
        WHEN 'Martes' THEN 2
        WHEN 'Miercoles' THEN 3
        WHEN 'Jueves' THEN 4
        WHEN 'Viernes' THEN 5
        WHEN 'Sabado' THEN 6
        WHEN 'Domingo' THEN 7
    END;