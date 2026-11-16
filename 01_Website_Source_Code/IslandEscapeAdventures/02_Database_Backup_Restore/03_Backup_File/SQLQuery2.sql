USE master;
GO
PRINT 'Island Escape Adventures - final backup/restore evidence run';
PRINT 'Run time: ' + CONVERT(varchar(19), GETDATE(), 120);
GO

BACKUP DATABASE IslandEscapeDB
TO DISK = N'C:\SQLBackups\IslandEscapeDB_latest.bak'
WITH FORMAT, INIT, NO_COMPRESSION, CHECKSUM,
     NAME = N'IslandEscapeDB Manual Evidence Backup',
     STATS = 25;
GO

RESTORE VERIFYONLY
FROM DISK = N'C:\SQLBackups\IslandEscapeDB_latest.bak'
WITH CHECKSUM;
GO

DECLARE @restoreDb sysname = N'IslandEscapeDB_RestoreEvidence';
DECLARE @dataLogical sysname = (SELECT TOP 1 name FROM IslandEscapeDB.sys.database_files WHERE type = 0);
DECLARE @logLogical sysname = (SELECT TOP 1 name FROM IslandEscapeDB.sys.database_files WHERE type = 1);
DECLARE @sql nvarchar(max);

IF DB_ID(@restoreDb) IS NOT NULL
BEGIN
    SET @sql = N'ALTER DATABASE ' + QUOTENAME(@restoreDb) + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ' + QUOTENAME(@restoreDb) + N';';
    EXEC (@sql);
END

SET @sql = N'RESTORE DATABASE ' + QUOTENAME(@restoreDb) + N'
FROM DISK = N''C:\SQLBackups\IslandEscapeDB_latest.bak''
WITH MOVE N''' + REPLACE(@dataLogical, '''', '''''') + N''' TO N''C:\SQLBackups\IslandEscapeDB_RestoreEvidence.mdf'',
     MOVE N''' + REPLACE(@logLogical, '''', '''''') + N''' TO N''C:\SQLBackups\IslandEscapeDB_RestoreEvidence_log.ldf'',
     REPLACE, RECOVERY, CHECKSUM, STATS = 25;';
EXEC (@sql);
GO

SELECT j.name AS JobName,
       j.enabled AS JobEnabled,
       s.name AS ScheduleName,
       s.freq_interval AS FrequencyInterval_62MeansMonToSat,
       RIGHT('000000' + CONVERT(varchar(6), s.active_start_time), 6) AS StartTime_020000,
       j.notify_level_email AS NotifyLevelEmail_2MeansOnFailure,
       o.email_address AS OperatorEmail
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobschedules js ON j.job_id = js.job_id
JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
LEFT JOIN msdb.dbo.sysoperators o ON j.notify_email_operator_id = o.id
WHERE j.name = N'IslandEscapeDB Daily Backup';

SELECT name, state_desc, create_date
FROM sys.databases
WHERE name IN (N'IslandEscapeDB', N'IslandEscapeDB_RestoreEvidence');

SELECT TOP 5 database_name, backup_start_date, backup_finish_date, type, has_backup_checksums
FROM msdb.dbo.backupset
WHERE database_name = N'IslandEscapeDB'
ORDER BY backup_finish_date DESC;
