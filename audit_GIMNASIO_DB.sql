CREATE SERVER AUDIT server_audit_GIMNASIO_DB
TO FILE (
    FILEPATH = 'C:\audits_GIMNASIO_DB\', 
    MAXSIZE = 10 MB,
    MAX_ROLLOVER_FILES = 5
)
WITH (ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT server_audit_GIMNASIO_DB
WITH (STATE = ON);
GO

USE [GIMNASIO_DB]
GO
CREATE DATABASE AUDIT SPECIFICATION audit_spec_GIMNASIO_DB
FOR SERVER AUDIT server_audit_GIMNASIO_DB
-- Pagos realizados por socios
ADD (INSERT ON dbo.Pago BY Rol_PagosManager),
ADD (UPDATE ON dbo.Pago BY Rol_PagosManager),

--Asignación de sueldos a entrenadores
ADD (UPDATE ON dbo.Entrenador BY Rol_Gerente),

--Inscripciones hechas por recepción
ADD (INSERT ON dbo.Socio BY Rol_Recepcionista),

--Socios con mora modificaciones al campo de estado de pago
ADD (UPDATE ON dbo.Socio BY Rol_PagosManager),

--Lecturas o consultas sensibles por parte del auditor
ADD (SELECT ON SCHEMA::dbo BY Rol_Auditor),

--Operaciones críticas borrado de datos
ADD (DELETE ON SCHEMA::dbo BY PUBLIC)
WITH (STATE = ON);
GO

USE GIMNASIO_DB
GO
-- Ver todos los detalles asociados a cada audit specification
SELECT * 
FROM sys.database_audit_specification_details;

--ver la audit file
SELECT * 
FROM sys.fn_get_audit_file('C:\audits_GIMNASIO_DB\*.sqlaudit', DEFAULT, DEFAULT);