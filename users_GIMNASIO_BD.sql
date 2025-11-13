USE GIMNASIO_DB;

--Creacion de usuarios de la base autocontenida:
CREATE USER U_BackupOperator WITH PASSWORD = 'Backup1234@';
CREATE USER U_ClassManager WITH PASSWORD = 'ClassM1234@';
CREATE USER U_PagosManager WITH PASSWORD = 'PagosM1234@';
CREATE USER U_Recepcion WITH PASSWORD = 'Recep1234@';
CREATE USER U_Entrenador WITH PASSWORD ='Entre1234@';
CREATE USER U_Gerente WITH PASSWORD ='Gerente1234@';
CREATE USER U_Auditor WITH PASSWORD ='Audit1234@';
CREATE USER U_LectorBI WITH PASSWORD ='LectorBI1234@';

--Creacion de roles y asignacion de los usuarios a sus roles
CREATE ROLE Rol_BackupOperator;
ALTER ROLE Rol_BackupOperator ADD MEMBER U_BackupOperator;

CREATE ROLE Rol_ClassManager;
ALTER ROLE Rol_ClassManager ADD MEMBER U_ClassManager;

CREATE ROLE Rol_PagosManager;
ALTER ROLE Rol_PagosManager ADD MEMBER U_PagosManager;

CREATE ROLE Rol_Recepcionista;
ALTER ROLE Rol_Recepcionista ADD MEMBER U_Recepcion;

CREATE ROLE Rol_Entrenador;
ALTER ROLE Rol_Entrenador ADD MEMBER U_Entrenador;

CREATE ROLE Rol_Gerente;
ALTER ROLE Rol_Gerente ADD MEMBER U_Gerente;

CREATE ROLE Rol_Auditor
ALTER ROLE Rol_Auditor ADD MEMBER U_Auditor;

ALTER ROLE db_datareader ADD MEMBER U_LectorBI;

--Permisos y denegaciones de cada rol:

--Rol operador:
GRANT BACKUP DATABASE TO Rol_BackupOperator;
GRANT BACKUP LOG TO Rol_BackupOperator;

DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Rol_BackupOperator;

--Rol manager de clases
GRANT UPDATE, SELECT ON dbo.Clase TO Rol_ClassManager;
GRANT UPDATE, SELECT ON dbo.Grupo_de_Clase TO Rol_ClassManager;
GRANT SELECT ON dbo.Entrenador TO Rol_ClassManager;

DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Pago TO Rol_ClassManager;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Socio TO Rol_ClassManager;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Reserva TO Rol_ClassManager;

--Rol manager de pagos
GRANT SELECT, INSERT, UPDATE ON dbo.Pago TO Rol_PagosManager;
GRANT SELECT ON dbo.Entrenador TO Rol_PagosManager;
GRANT SELECT ON dbo.Socio TO Rol_PagosManager;
GRANT SELECT ON dbo.Clase TO Rol_PagosManager;
GRANT SELECT ON dbo.Reserva TO Rol_PagosManager;
GRANT SELECT ON dbo.Grupos_de_Clase TO Rol_PagosManager;

DENY UPDATE, INSERT, DELETE ON dbo.Entrenador TO Rol_PagosManager;
DENY UPDATE, INSERT, DELETE ON dbo.Socio TO Rol_PagosManager;
DENY UPDATE, INSERT, DELETE ON dbo.Clase TO Rol_PagosManager;
DENY UPDATE, INSERT, DELETE ON dbo.Grupos_de_Clase TO Rol_PagosManager;

--Rol Recepcionista
GRANT INSERT, SELECT ON dbo.Socio TO Rol_Recepcionista;
GRANT INSERT, SELECT ON dbo.Reserva TO Rol_Recepcionista;
GRANT SELECT ON dbo.Grupos_de_Clase TO Rol_Recepcionista;

DENY DELETE, UPDATE ON dbo.Socio TO Rol_Recepcionista;
DENY DELETE, UPDATE ON dbo.Reserva TO Rol_Recepcionista;
DENY INSERT, DELETE, UPDATE ON dbo.Grupos_de_Clase TO Rol_Recepcionista;

--Rol Entrenador
GRANT SELECT ON dbo.Clase TO Rol_Entrenador;
GRANT SELECT, UPDATE ON dbo.Grupos_de_Clase TO Rol_Entrenador;
GRANT SELECT ON dbo.Socio TO Rol_Entrenador;
GRANT SELECT ON dbo.Reserva TO Rol_Entrenador;

DENY INSERT, UPDATE, DELETE ON dbo.Clase TO Rol_Entrenador;
DENY INSERT, UPDATE, DELETE ON dbo.Grupos_de_Clase TO Rol_Entrenador;
DENY INSERT, UPDATE, DELETE ON dbo.Socio TO Rol_Entrenador;
DENY INSERT, UPDATE, DELETE ON dbo.Reserva TO Rol_Entrenador;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Entrenador TO Rol_Entrenador;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Pago TO Rol_Entrenador;

--Rol gerente
GRANT SELECT, INSERT, UPDATE ON dbo.Socio TO Rol_Gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.Entrenador TO Rol_Gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.Grupos_de_Clase TO Rol_Gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.Clase TO Rol_Gerente;
GRANT SELECT ON dbo.Reserva TO Rol_Gerente;
GRANT SELECT ON dbo.Pago TO Rol_Gerente;

DENY DELETE ON dbo.Pago TO Rol_Gerente;
DENY DELETE ON dbo.Reserva TO Rol_Gerente;
DENY DELETE ON dbo.Socio TO Rol_Gerente;
DENY DELETE ON dbo.Entrenador TO Rol_Gerente;
DENY DELETE ON dbo.Clase TO Rol_Gerente;
DENY DELETE ON dbo.Grupos_de_Clase TO Rol_Gerente;