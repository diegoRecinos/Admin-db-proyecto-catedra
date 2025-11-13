use master
ALTER DATABASE ABD_Laboratorio1 SET CONTAINMENT = FULL
ALTER DATABASE ABD_Laboratorio1 SET CONTAINMENT = PARTIAL;
use ABD_Laboratorio1
--Creando usuarios (autocontenidos)
CREATE USER BackupOperator WITH PASSWORD='Backup1234@';
CREATE USER ClassManager WITH PASSWORD ='Class1234@';
CREATE USER PagosManager WITH PASSWORD ='Pagos1234@';
CREATE USER Recepcion WITH PASSWORD ='Recep1234@';
CREATE USER Entrenador WITH PASSWORD ='Entre1234@';
CREATE USER Gerente WITH PASSWORD ='Gerente1234@';
CREATE USER Auditor WITH PASSWORD ='Audit1234@';
CREATE USER LectorBI WITH PASSWORD ='LectorBI1234@';



-- Creando roles
CREATE ROLE Rol_BackupOperator;
CREATE ROLE Rol_ClassManager;
CREATE ROLE Rol_PagosManager;
CREATE ROLE Rol_Recepcionista;
CREATE ROLE Rol_Entrenador;
CREATE ROLE Rol_Gerente;
CREATE ROLE Rol_Auditor;
--El rol de LectorBI sera el predeterminador por SQL SERVER, es decir se utilizara el db_datareader

--Otorgando permisos a roles y denegando
GRANT BACKUP DATABASE TO Rol_BackupOperator;
GRANT BACKUP LOG TO Rol_BackupOperator;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Rol_BackupOperator;
/*Otros esquemas seran denegados luego*/

GRANT UPDATE ON Clases TO Rol_ClassManager;
GRANT UPDATE ON Grupos_deClase TO Rol_ClassManager;
GO


GRANT SELECT, INSERT, UPDATE ON Pagos TO Rol_PagosManager;
GRANT SELECT ON Entrenador TO Rol_PagosManager;
GRANT SELECT ON Socio TO Rol_PagosManager;
GRANT SELECT ON Clases TO Rol_PagosManager;
GRANT SELECT ON Reservas TO Rol_PagosManager;
GRANT SELECT ON Grupos_deClase TO Rol_PagosManager;

DENY UPDATE ON Entrenador TO Rol_PagosManager;
DENY UPDATE ON Socio TO Rol_PagosManager;
DENY UPDATE ON Clases TO Rol_PagosManager;
DENY UPDATE ON Grupos_deClase TO Rol_PagosManager;


GRANT INSERT ON Socio TO Rol_Recepcionista;
GRANT INSERT ON Reservas TO Rol_Recepcionista;
GRANT SELECT ON Grupos_deClase TO Rol_Recepcionista;
GO



GRANT SELECT ON Clases TO Rol_Entrenador;
GRANT SELECT ON Grupos_deClase TO Rol_Entrenador;
GRANT SELECT ON Socio TO Rol_Entrenador;
GRANT SELECT ON Reservas TO Rol_Entrenador;
GRANT UPDATE ON Grupos_deClase TO Rol_Entrenador;
-- Denegando acceso a informacion sensible
DENY SELECT, UPDATE ON Entrenador TO Rol_Entrenador;
DENY SELECT ON Pagos TO Rol_Entrenador;



GRANT SELECT ON Socio TO Rol_Gerente;
GRANT SELECT ON Entrenador TO Rol_Gerente;
GRANT SELECT ON Grupos_deClase TO Rol_Gerente;
GRANT SELECT ON Clases TO Rol_Gerente;
GRANT SELECT ON Reservas TO Rol_Gerente;
GRANT SELECT ON Pagos TO Rol_Gerente;

GRANT UPDATE, INSERT ON Clases TO Rol_Gerente;
GRANT UPDATE, INSERT ON Entrenador TO Rol_Gerente;
GRANT UPDATE, INSERT ON Grupos_deClase TO Rol_Gerente;
GRANT UPDATE, INSERT ON Socio TO Rol_Gerente;
-- Denegando DELETE en tablas importantes para la Auditoria
DENY DELETE ON Pagos TO Rol_Gerente;
DENY DELETE ON Reservas TO Rol_Gerente;



GRANT SELECT ON SCHEMA::dbo TO Rol_Auditor;
/*Se agregaran todos los demas esquemas*/
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Rol_Auditor;
/*Se denegaran permisos en todos los demas esquemas*/




--Uniendo rol con usuario

ALTER ROLE Rol_BackupOperator ADD MEMBER BackupOp;
ALTER ROLE Rol_ClassManager ADD MEMBER ClassMgr;
ALTER ROLE Rol_PagosManager ADD MEMBER PagosMgr;
ALTER ROLE Rol_Recepcionista ADD MEMBER Recepcion;
ALTER ROLE Rol_Entrenador ADD MEMBER Entrenador1;
ALTER ROLE Rol_Gerente ADD MEMBER Gerente;
ALTER ROLE Rol_Auditor ADD MEMBER Auditor;
--Asignando rool predefinido para el rol de lector
ALTER ROLE db_datareader ADD MEMBER LectorBI;


