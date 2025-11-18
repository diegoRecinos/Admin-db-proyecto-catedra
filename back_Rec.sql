USE master;
GO
---COMIENZO DE EL APARTADO BACKUPS---
--realizamos este comando para asegurarnos que la base de datos este en el modo full recovery 
ALTER DATABASE GIMNASIO_DB SET RECOVERY FULL;
GO
--Codigo para realizar el respaldo completo de la base de datos
BACKUP DATABASE GIMNASIO_DB
TO DISK = 'C:\Temp_backup\GIMNASIO_DB_FULL.bak'
WITH INIT, FORMAT, NAME = 'Backup FULL de GIMNASIO_DB';
GO
--codigo para generar el backup diferencial
BACKUP DATABASE GIMNASIO_DB
TO DISK = 'C:\Temp_backup\GIMNASIO_DB_DIFF.bak'
WITH DIFFERENTIAL, INIT, NAME = 'Backup diferencial';
GO
--codigo para generar el respaldo del LOG
BACKUP LOG GIMNASIO_DB
TO DISK = 'C:\Temp_backup\GIMNASIO_DB_LOG_TAIL.trn'
WITH INIT, NO_TRUNCATE, NAME = 'Backup Log Post Desastre';
GO
---FIN DE LOS BACKUPS---

---COMIENZO DE LA RESTAURACION---
--restauramos la base completa y diferencial, con los respaldos realizados previamente
RESTORE DATABASE GIMNASIO_DB
FROM DISK = 'C:\Temp_backup\GIMNASIO_DB_FULL.bak'
WITH NORECOVERY, REPLACE;
GO

RESTORE DATABASE GIMNASIO_DB
FROM DISK = 'C:\Temp_backup\GIMNASIO_DB_DIFF.bak'
WITH NORECOVERY;
GO

--restauramos el LOG
RESTORE LOG GIMNASIO_DB
FROM DISK = 'C:\Temp_backup\GIMNASIO_DB_LOG_TAIL.trn'
WITH RECOVERY; 
GO