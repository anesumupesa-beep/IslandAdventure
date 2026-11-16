# Database Backup and Restore Evidence

Date completed: 31 July 2026
Tool used: SQL Server Management Studio 22 connected to `localhost`.

## Evidence files

- `01-ssms-job-schedule-restore-results.jpg` - Full SSMS results showing SQL Server Agent job metadata, Monday-Saturday 02:00 schedule, failure notification operator email, restored evidence database, and backup history.
- `02-ssms-backup-restore-messages.jpg` - Full SSMS messages showing backup processing, `RESTORE VERIFYONLY`, and restore to `IslandEscapeDB_RestoreEvidence`.
- `03-restore-results-crop.jpg` - Restore-focused crop showing `IslandEscapeDB_RestoreEvidence` online and backup history.
- `04-restore-success-messages-crop.jpg` - Restore-focused crop showing successful `RESTORE VERIFYONLY` and `RESTORE DATABASE` messages.

## Backup job evidence

The SQL Server Agent job `IslandEscapeDB Daily Backup` was created in `msdb` with:

- Schedule: Monday to Saturday at 02:00.
- Backup target: `C:\SQLBackups\IslandEscapeDB_latest.bak`.
- Retry settings: 2 retry attempts, 5 minute interval.
- Failure notification operator: `Island Escape Administrator`, `admin@islandescape.mu`.

Note: SQL Server Agent service could not be started from this session due Windows service permissions, but the job metadata, schedule, and notification settings were created and captured in SSMS.

## Restore process evidence

The restore process is documented separately in the report. A clean manual evidence backup was created with `CHECKSUM` and copied to `DatabaseBackups/IslandEscapeDB_latest.bak` for submission. The backup was verified with `RESTORE VERIFYONLY WITH CHECKSUM`, then restored into a separate database named `IslandEscapeDB_RestoreEvidence` to prove the latest backup restores successfully without overwriting the working application database.
