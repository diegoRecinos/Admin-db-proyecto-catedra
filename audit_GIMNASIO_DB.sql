USE [master]
CREATE SERVER AUDIT server_audit_GIMNASIO_DB
TO FILE (
    FILEPATH = 'C:\audits_GIMNASIO_DB\', 
    MAXSIZE = 10 MB,
    MAX_ROLLOVER_FILES = 5
)
WITH (ON_FAILURE = CONTINUE);
GO

USE [master]
ALTER SERVER AUDIT server_audit_GIMNASIO_DB
WITH (STATE = ON);
GO

/*Server audit spec*/
CREATE SERVER AUDIT SPECIFICATION audit_server_spec_GIMNASIO_DB
FOR SERVER AUDIT server_audit_GIMNASIO_DB

-- Cambios de objetos/bases
ADD (DATABASE_OBJECT_CHANGE_GROUP),
ADD (SCHEMA_OBJECT_CHANGE_GROUP),

-- Cambios de permisos
ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP),
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP),
ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),

-- Seguridad del servidor
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (SERVER_PERMISSION_CHANGE_GROUP),

-- Logins
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP)

WITH (STATE = ON);
GO

/*Database audit spec*/
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
SELECT 
event_time,
action_id,
succeeded,
server_principal_name,
database_name,
schema_name, 
object_name,
statement,
additional_information
FROM sys.fn_get_audit_file('C:\audits_GIMNASIO_DB\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;

/*EJEMPLO ACCIONES CON AUDITORIA */

/*Asignación de sueldos a entrenadores UPDATE en Entrenador por Rol_Gerente*/
USE GIMNASIO_DB;
GO

EXECUTE AS USER = 'U_Gerente';

UPDATE dbo.Entrenador
SET sueldo = sueldo + 100
WHERE Entrenador.Id = 1;

REVERT;

/*SELECTS para auditor*/
EXECUTE AS USER = 'U_Auditor';
SELECT * FROM dbo.Socio;
REVERT;

/*INSERT en SOCIO*/
EXECUTE AS USER = 'U_Recepcion';

INSERT INTO dbo.Socio (Nombre, Apellido, Email, Estado)
VALUES ('Prueba', 'Audit', 'audit@test.com', 'Activo');

REVERT;

/*UPDATE en en PAGO */
EXECUTE AS USER = 'U_PagosManager';

UPDATE dbo.Pago
SET Monto = 750
WHERE Pago.id_entrenador = 1;

REVERT;

/*DELETE en la db*/
USE GIMNASIO_DB;

EXECUTE AS USER = 'U_Recepcion';

DELETE FROM dbo.Socio WHERE Socio.Id = 999999;
/*Aunque no exista el registro igual se genera el evento*/

REVERT;

