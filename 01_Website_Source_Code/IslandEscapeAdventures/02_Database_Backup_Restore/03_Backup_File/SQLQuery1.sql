USE master;
GO
PRINT 'Island Escape Adventures - backup and restore evidence run';
PRINT 'Run time: ' + CONVERT(varchar(19), GETDATE(), 120);
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Agent XPs', 1;
RECONFIGURE;
GO

USE msdb;
GO
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'IslandEscapeDB Daily Backup')
BEGIN
    EXEC msdb.dbo.sp_delete_job @job_name = N'IslandEscapeDB Daily Backup';
END
GO

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = N'Island Escape Administrator')
BEGIN
    EXEC msdb.dbo.sp_add_operator
        @name = N'Island Escape Administrator',
        @enabled = 1,
        @email_address = N'admin@islandescape.mu';
END
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'IslandEscapeDB Daily Backup',
    @enabled = 1,
    @description = N'Backs up IslandEscapeDB daily except Sundays at 02:00 AM.';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'IslandEscapeDB Daily Backup',
    @step_name = N'Full database backup',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'BACKUP DATABASE IslandEscapeDB TO DISK = N''C:\SQLBackups\IslandEscapeDB_latest.bak'' WITH INIT, COMPRESSION, CHECKSUM, NAME = N''IslandEscapeDB Scheduled Full Backup'';',
    @retry_attempts = 2,
    @retry_interval = 5;
GO

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Monday to Saturday at 02:00',
    @enabled = 1,
    @freq_type = 8,
    @freq_interval = 62,
    @freq_recurrence_factor = 1,
    @active_start_time = 020000;
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'IslandEscapeDB Daily Backup',
    @schedule_name = N'Monday to Saturday at 02:00';
GO

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'IslandEscapeDB Daily Backup',
    @server_name = N'(LOCAL)';
GO

EXEC msdb.dbo.sp_update_job
    @job_name = N'IslandEscapeDB Daily Backup',
    @notify_level_email = 2,
    @notify_email_operator_name = N'Island Escape Administrator';
GO

USE master;
GO
BACKUP DATABASE IslandEscapeDB
TO DISK = N'C:\SQLBackups\IslandEscapeDB_latest.bak'
WITH INIT, COMPRESSION, CHECKSUM,
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

SELECT TOP 10 database_name, backup_start_date, backup_finish_date, type, is_copy_only, has_backup_checksums
FROM msdb.dbo.backupset
WHERE database_name = N'IslandEscapeDB'
ORDER BY backup_finish_date DESC;
