USE [master]
/*CREATE OR ALTER*/
CREATE SERVER AUDIT server_audit_GIMNASIO_DB
TO FILE (
    FILEPATH = 'C:\audits_GIMNASIO_DB\',
    MAXSIZE = 20 MB,
    MAX_ROLLOVER_FILES = 5
)
WITH (ON_FAILURE = CONTINUE);
GO

USE [master]
ALTER SERVER AUDIT server_audit_GIMNASIO_DB
WITH (STATE = ON);
GO

/*-------Server audit spec*/
CREATE SERVER AUDIT SPECIFICATION server_audit_spec_GIMNASIO_DB
FOR SERVER AUDIT server_audit_GIMNASIO_DB

-- Cambios de permisos
ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP),
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP),
ADD (DATABASE_PRINCIPAL_CHANGE_GROUP), --

-- Seguridad del servidor
ADD (SERVER_PRINCIPAL_CHANGE_GROUP), --Logins creados, eliminados, modificados
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP), --Agregar o quitar logins de roles de servidor
ADD (SERVER_PERMISSION_CHANGE_GROUP) --GRANT, DENY, REVOKE 

WITH (STATE = ON);
GO
/*-------*/

/*-------Database audit spec*/
USE [GIMNASIO_DB]
GO
CREATE DATABASE AUDIT SPECIFICATION audit_spec_GIMNASIO_DB
FOR SERVER AUDIT server_audit_GIMNASIO_DB

-- 1 Pagos realizados por socios o mora
ADD (INSERT ON dbo.Pago BY Rol_PagosManager),
ADD (UPDATE ON dbo.Pago BY Rol_PagosManager),

--2 Asignación de sueldos a entrenadores
ADD (UPDATE ON dbo.Entrenador BY Rol_Gerente),

--3 Inscripciones hechas por recepción
ADD (INSERT ON dbo.Socio BY Rol_Recepcionista),

--4 Socios con mora modificaciones al campo de estado de pago
ADD (UPDATE ON dbo.Socio BY PUBLIC),

--5 Lecturas o consultas sensibles por parte del auditor
ADD (SELECT ON SCHEMA::dbo BY Rol_Auditor),

--6 Operaciones críticas borrado de datos
ADD (DELETE ON SCHEMA::dbo BY PUBLIC)

WITH (STATE = ON);
GO
/*-----*/

-- Ver todos los detalles asociados a cada audit specification
/*server*/
SELECT *
FROM sys.server_audit_specification_details;

/*database*/
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

/*1 INSERT, UPDATE on Pago*/
USE GIMNASIO_DB;
GO

EXECUTE AS USER = 'U_PagosManager';
UPDATE dbo.Pago
SET Monto = 750
WHERE Pago.id_entrenador = 1;
REVERT;

/*2. UPDATE Asignación de sueldos a entrenadores UPDATE en Entrenador por Rol_Gerente*/
EXECUTE AS USER = 'U_Gerente';
UPDATE dbo.Entrenador
SET sueldo = sueldo + 100
WHERE Entrenador.Id = 1;
REVERT;

/*3 INSERT en SOCIO Rol_Recepcionista*/
EXECUTE AS USER = 'U_Recepcion';
INSERT INTO dbo.Socio (Nombre, Apellido, Email, Estado)
VALUES ('2Prueba', 'Audit', 'audit@test2.com', 'Activo');
REVERT;

/*4. UPDATE en SOCIO */
EXECUTE AS USER = 'U_Root'
UPDATE dbo.Socio
SET Socio.Nombre = 'auditest'
WHERE Socio.Id = 1;
REVERT

/*5. SELECTS para auditor*/
EXECUTE AS USER = 'U_Auditor';
SELECT * FROM dbo.Socio;
REVERT;

/*DELETE en la db*/
EXECUTE AS USER = 'U_Recepcion';
DELETE FROM dbo.Socio WHERE Socio.Id = 999999;
/*Aunque no exista el registro igual se genera el evento*/
REVERT;

