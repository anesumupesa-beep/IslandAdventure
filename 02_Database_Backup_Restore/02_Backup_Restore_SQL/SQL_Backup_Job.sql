USE msdb;
GO

-- Island Escape Adventures daily full backup job.
-- Schedule: Monday to Saturday at 02:00 AM.
-- Before running this script, configure Database Mail and replace
-- IslandEscapeMailProfile/admin@islandescape.mu with the real profile and administrator address.

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'IslandEscapeDB Daily Backup')
BEGIN
    EXEC msdb.dbo.sp_delete_job @job_name = N'IslandEscapeDB Daily Backup';
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
    @command = N'
DECLARE @BackupFile nvarchar(4000);
SET @BackupFile = N''C:\SQLBackups\IslandEscapeDB_'' +
                  CONVERT(nvarchar(8), GETDATE(), 112) + N''.bak'';

BACKUP DATABASE IslandEscapeDB
TO DISK = @BackupFile
WITH INIT, COMPRESSION, CHECKSUM,
     NAME = N''IslandEscapeDB Scheduled Full Backup'';
',
    @database_name = N'master',
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

-- Optional failure notification once Database Mail and an operator are configured:
-- EXEC msdb.dbo.sp_add_operator
--     @name = N'Island Escape Administrator',
--     @enabled = 1,
--     @email_address = N'admin@islandescape.mu';
--
-- EXEC msdb.dbo.sp_update_job
--     @job_name = N'IslandEscapeDB Daily Backup',
--     @notify_level_email = 2,
--     @notify_email_operator_name = N'Island Escape Administrator';
GO
