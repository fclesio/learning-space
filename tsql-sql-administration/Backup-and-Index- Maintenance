use master
go

/*Sample 
EXECUTE dbo.IndexOptimize @Databases = 'USER_DATABASES',
@FragmentationHigh_LOB = 'INDEX_REBUILD_OFFLINE', @FragmentationHigh_NonLOB = 'INDEX_REBUILD_ONLINE',
@FragmentationMedium_LOB = 'INDEX_REORGANIZE', @FragmentationMedium_NonLOB = 'INDEX_REORGANIZE',
@FragmentationLow_LOB = 'NOTHING', @FragmentationLow_NonLOB = 'NOTHING',
@FragmentationLevel1 = 5, @FragmentationLevel2 = 30, @PageCountLevel = 1000 

*/

/*

SQL Server Index Optimization.

*/

USE master -- <== This is the database that the objects will be created in.

SET NOCOUNT ON

DECLARE @BackupDirectory nvarchar(max)
DECLARE @CreateJobs nvarchar(max)
DECLARE @Error int

SET @BackupDirectory = N'C:\Backup' -- <== Change this to your backup directory.

SET @CreateJobs = 'N' -- <== Should jobs be created, 'Y' or 'N'?

SET @Error = 0

IF IS_SRVROLEMEMBER('sysadmin') = 0
BEGIN
  RAISERROR('The server role SysAdmin is needed for the installation.',16,1)
  SET @Error = @@ERROR
END

IF CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))-1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,9)) < 9.003042
BEGIN
  RAISERROR('The solution is supported on SQL Server 2005 and SQL Server 2008. Service Pack 2 is required on SQL Server 2005.',16,1)
  SET @Error = @@ERROR
END

IF (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) < 90
BEGIN
  RAISERROR('The database that you are creating the objects in has to be in compatibility_level 90 or 100.',16,1)
  SET @Error = @@ERROR
END

IF (SELECT collation_name FROM sys.databases WHERE database_id = DB_ID()) <> (SELECT collation_name FROM sys.databases WHERE [name] = 'tempdb')
BEGIN
  RAISERROR('The database that you are creating the objects in has to have the same collation as tempdb.',16,1)
  SET @Error = @@ERROR
END

IF (SELECT value_in_use FROM sys.configurations WHERE name = 'Agent XPs') <> 1
BEGIN
  RAISERROR('The SQL Server Agent has to be started.',16,1)
  SET @Error = @@ERROR
END

IF OBJECT_ID('tempdb..#Config') IS NOT NULL DROP TABLE #Config

CREATE TABLE #Config ([Name] nvarchar(max),
                      [Value] nvarchar(max))

DECLARE @ErrorLog TABLE (LogDate datetime,
                         ProcessInfo nvarchar(max),
                         ErrorText nvarchar(max))

INSERT INTO @ErrorLog (LogDate, ProcessInfo, ErrorText)
EXECUTE [master].dbo.sp_readerrorlog 0

INSERT INTO #Config ([Name], [Value])
SELECT 'LogDirectory', REPLACE(REPLACE(ErrorText,'Logging SQL Server messages in file ''',''),'\ERRORLOG''.','')
FROM @ErrorLog
WHERE ErrorText LIKE 'Logging SQL Server messages in file%'

IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
BEGIN
  RAISERROR('The log directory could not be found.',16,1)
  SET @Error = @@ERROR  
END

INSERT INTO #Config ([Name], [Value])
VALUES('BackupDirectory', @BackupDirectory)

INSERT INTO #Config ([Name], [Value])
VALUES('Database', DB_NAME(DB_ID()))

INSERT INTO #Config ([Name], [Value])
VALUES('Jobs', @CreateJobs)

INSERT INTO #Config ([Name], [Value])
VALUES('Error', CAST(@Error AS nvarchar))

IF OBJECT_ID('dbo.DatabaseBackup') IS NOT NULL DROP PROCEDURE dbo.DatabaseBackup
IF OBJECT_ID('dbo.DatabaseIntegrityCheck') IS NOT NULL DROP PROCEDURE dbo.DatabaseIntegrityCheck
IF OBJECT_ID('dbo.IndexOptimize') IS NOT NULL DROP PROCEDURE dbo.IndexOptimize
IF OBJECT_ID('dbo.CommandExecute') IS NOT NULL DROP PROCEDURE dbo.CommandExecute
IF OBJECT_ID('dbo.DatabaseSelect') IS NOT NULL DROP FUNCTION dbo.DatabaseSelect
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DatabaseSelect] (@DatabaseList nvarchar(max))

RETURNS @Database TABLE(DatabaseName nvarchar(max) NOT NULL)

AS

BEGIN

  DECLARE @Database01 TABLE(DatabaseName nvarchar(max),
                            DatabaseStatus bit)

  DECLARE @Database02 TABLE(DatabaseName nvarchar(max),
                            DatabaseStatus bit)

  DECLARE @DatabaseItem nvarchar(max)
  DECLARE @Position int

  SET @DatabaseList = LTRIM(RTRIM(@DatabaseList))
  SET @DatabaseList = REPLACE(@DatabaseList,' ','')
  SET @DatabaseList = REPLACE(@DatabaseList,'[','')
  SET @DatabaseList = REPLACE(@DatabaseList,']','')
  SET @DatabaseList = REPLACE(@DatabaseList,'''','')
  SET @DatabaseList = REPLACE(@DatabaseList,'"','')

  WHILE CHARINDEX(',,',@DatabaseList) > 0 SET @DatabaseList = REPLACE(@DatabaseList,',,',',')

  IF RIGHT(@DatabaseList,1) = ',' SET @DatabaseList = LEFT(@DatabaseList,LEN(@DatabaseList) - 1)
  IF LEFT(@DatabaseList,1) = ','  SET @DatabaseList = RIGHT(@DatabaseList,LEN(@DatabaseList) - 1)

  WHILE LEN(@DatabaseList) > 0
  BEGIN
    SET @Position = CHARINDEX(',', @DatabaseList)
    IF @Position = 0
    BEGIN
      SET @DatabaseItem = @DatabaseList
      SET @DatabaseList = ''
    END
    ELSE
    BEGIN
      SET @DatabaseItem = LEFT(@DatabaseList, @Position - 1)
      SET @DatabaseList = RIGHT(@DatabaseList, LEN(@DatabaseList) - @Position)
    END
    INSERT INTO @Database01 (DatabaseName) VALUES(@DatabaseItem)
  END

  UPDATE @Database01
  SET DatabaseStatus = 1
  WHERE DatabaseName NOT LIKE '-%'

  UPDATE @Database01
  SET  DatabaseName = RIGHT(DatabaseName,LEN(DatabaseName) - 1), DatabaseStatus = 0
  WHERE DatabaseName LIKE '-%'

  INSERT INTO @Database02 (DatabaseName, DatabaseStatus)
  SELECT DISTINCT DatabaseName, DatabaseStatus
  FROM @Database01
  WHERE DatabaseName NOT IN('SYSTEM_DATABASES','USER_DATABASES')

  IF EXISTS (SELECT * FROM @Database01 WHERE DatabaseName = 'SYSTEM_DATABASES' AND DatabaseStatus = 0)
  BEGIN
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('master', 0)
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('model', 0)
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('msdb', 0)
  END

  IF EXISTS (SELECT * FROM @Database01 WHERE DatabaseName = 'SYSTEM_DATABASES' AND DatabaseStatus = 1)
  BEGIN
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('master', 1)
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('model', 1)
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus) VALUES('msdb', 1)
  END

  IF EXISTS (SELECT * FROM @Database01 WHERE DatabaseName = 'USER_DATABASES' AND DatabaseStatus = 0)
  BEGIN
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus)
    SELECT [name], 0
    FROM sys.databases
    WHERE database_id > 4
  END

  IF EXISTS (SELECT * FROM @Database01 WHERE DatabaseName = 'USER_DATABASES' AND DatabaseStatus = 1)
  BEGIN
    INSERT INTO @Database02 (DatabaseName, DatabaseStatus)
    SELECT [name], 1
    FROM sys.databases
    WHERE database_id > 4
  END

  INSERT INTO @Database (DatabaseName)
  SELECT [name]
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  INTERSECT
  SELECT DatabaseName
  FROM @Database02
  WHERE DatabaseStatus = 1
  EXCEPT
  SELECT DatabaseName
  FROM @Database02
  WHERE DatabaseStatus = 0

  RETURN

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CommandExecute]

@Command nvarchar(max),
@Comment nvarchar(max),
@Mode int

AS

SET NOCOUNT ON

SET LOCK_TIMEOUT 3600000

----------------------------------------------------------------------------------------------------
--// Declare variables                                                                          //--
----------------------------------------------------------------------------------------------------

DECLARE @StartMessage nvarchar(max)
DECLARE @EndMessage nvarchar(max)
DECLARE @ErrorMessage nvarchar(max)

DECLARE @Error int

SET @Error = 0

----------------------------------------------------------------------------------------------------
--// Check input parameters                                                                     //--
----------------------------------------------------------------------------------------------------

IF @Command IS NULL OR @Command = ''
BEGIN
  SET @ErrorMessage = 'The value for parameter @Command is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @Comment IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @Comment is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @Mode NOT IN(1,2) OR @Mode IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @Mode is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check error variable                                                                       //--
----------------------------------------------------------------------------------------------------

IF @Error <> 0 GOTO ReturnCode

----------------------------------------------------------------------------------------------------
--// Log initial information                                                                    //--
----------------------------------------------------------------------------------------------------

SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Command: ' + @Command
IF @Comment <> '' SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10) + 'Comment: ' + @Comment

RAISERROR(@StartMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
--// Execute command                                                                            //--
----------------------------------------------------------------------------------------------------

IF @Mode = 1
BEGIN
  EXECUTE(@Command)
  SET @Error = @@ERROR
END

IF @Mode = 2
BEGIN
  BEGIN TRY
    EXECUTE(@Command)
  END TRY
  BEGIN CATCH
    SET @Error = ERROR_NUMBER()
    SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  END CATCH
END

----------------------------------------------------------------------------------------------------
--// Log completing information                                                                 //--
----------------------------------------------------------------------------------------------------

SET @EndMessage = 'Outcome: ' + CASE WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END + CHAR(13) + CHAR(10)
SET @EndMessage = @EndMessage + 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)

RAISERROR(@EndMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
--// Return code                                                                                //--
----------------------------------------------------------------------------------------------------

ReturnCode:

RETURN @Error

----------------------------------------------------------------------------------------------------
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseBackup]

@Databases nvarchar(max),
@Directory nvarchar(max),
@BackupType nvarchar(max),
@Verify nvarchar(max),
@CleanupTime int

AS

SET NOCOUNT ON

----------------------------------------------------------------------------------------------------
--// Declare variables                                                                          //--
----------------------------------------------------------------------------------------------------

DECLARE @StartMessage nvarchar(max)
DECLARE @EndMessage nvarchar(max)
DECLARE @DatabaseMessage nvarchar(max)
DECLARE @ErrorMessage nvarchar(max)

DECLARE @InstanceName nvarchar(max)
DECLARE @FileExtension nvarchar(max)

DECLARE @CurrentID int
DECLARE @CurrentDatabase nvarchar(max)
DECLARE @CurrentDatabaseFS nvarchar(max)
DECLARE @CurrentDirectory nvarchar(max)
DECLARE @CurrentDate nvarchar(max)
DECLARE @CurrentFileName nvarchar(max)
DECLARE @CurrentFilePath nvarchar(max)
DECLARE @CurrentCleanupTime nvarchar(max)

DECLARE @CurrentCommand01 nvarchar(max)
DECLARE @CurrentCommand02 nvarchar(max)
DECLARE @CurrentCommand03 nvarchar(max)
DECLARE @CurrentCommand04 nvarchar(max)

DECLARE @CurrentCommandOutput01 int
DECLARE @CurrentCommandOutput02 int
DECLARE @CurrentCommandOutput03 int
DECLARE @CurrentCommandOutput04 int

DECLARE @DirectoryInfoCommand nvarchar(max)

DECLARE @DirectoryInfo TABLE (FileExists bit,
                              FileIsADirectory bit,
                              ParentDirectoryExists bit)

DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                             DatabaseName nvarchar(max),
                             Completed bit)

DECLARE @Error int

SET @Error = 0

----------------------------------------------------------------------------------------------------
--// Log initial information                                                                    //--
----------------------------------------------------------------------------------------------------

SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @Directory = ' + ISNULL('''' + REPLACE(@Directory,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @BackupType = ' + ISNULL('''' + REPLACE(@BackupType,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @Verify = ' + ISNULL('''' + REPLACE(@Verify,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL')
SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10)

RAISERROR(@StartMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
--// Select databases                                                                           //--
----------------------------------------------------------------------------------------------------

IF @Databases IS NULL OR @Databases = ''
BEGIN
  SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

INSERT INTO @tmpDatabases (DatabaseName, Completed)
SELECT DatabaseName AS DatabaseName,
       0 AS Completed
FROM dbo.DatabaseSelect (@Databases)
ORDER BY DatabaseName ASC

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
BEGIN
  SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check directory                                                                            //--
----------------------------------------------------------------------------------------------------

IF NOT (@Directory LIKE '_:' OR @Directory LIKE '_:\%' OR @Directory LIKE '\\%\%') OR @Directory LIKE '%\' OR @Directory IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @Directory is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

SET @DirectoryInfoCommand = 'EXECUTE xp_fileexist ''' + REPLACE(@Directory,'''','''''') + ''''

INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
EXECUTE(@DirectoryInfoCommand)

IF NOT EXISTS (SELECT * FROM @DirectoryInfo WHERE FileExists = 0 AND FileIsADirectory = 1 AND ParentDirectoryExists = 1)
BEGIN
  SET @ErrorMessage = 'The directory does not exist.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check backup type                                                                          //--
----------------------------------------------------------------------------------------------------

SET @BackupType = UPPER(@BackupType)

IF @BackupType NOT IN ('FULL','DIFF','LOG') OR @BackupType IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @BackupType is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check Verify input                                                                         //--
----------------------------------------------------------------------------------------------------

IF @Verify NOT IN ('Y','N') OR @Verify IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @Verify is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check CleanupTime input                                                                    //--
----------------------------------------------------------------------------------------------------

IF @CleanupTime < 0 OR @CleanupTime IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @CleanupTime is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check error variable                                                                       //--
----------------------------------------------------------------------------------------------------

IF @Error <> 0 GOTO Logging

----------------------------------------------------------------------------------------------------
--// Set global variables                                                                       //--
----------------------------------------------------------------------------------------------------

SET @InstanceName = REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar),'\','$')

SELECT @FileExtension = CASE
WHEN @BackupType = 'FULL' THEN 'bak'
WHEN @BackupType = 'DIFF' THEN 'bak'
WHEN @BackupType = 'LOG' THEN 'trn'
END

----------------------------------------------------------------------------------------------------
--// Execute backup commands                                                                    //--
----------------------------------------------------------------------------------------------------

WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
BEGIN

  SELECT TOP 1 @CurrentID = ID,
               @CurrentDatabase = DatabaseName
  FROM @tmpDatabases
  WHERE Completed = 0
  ORDER BY ID ASC

  -- Set database message
  SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabase) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabase,'status') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabase,'recovery') AS nvarchar) + CHAR(13) + CHAR(10)
  RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

  IF DATABASEPROPERTYEX(@CurrentDatabase,'status') = 'ONLINE' AND NOT (@BackupType = 'LOG' AND DATABASEPROPERTYEX(@CurrentDatabase,'recovery') = 'SIMPLE')
  BEGIN

    SET @CurrentDatabaseFS = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@CurrentDatabase,'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''),' ','')
    IF @CurrentDatabaseFS = '' SET @CurrentDatabaseFS = '_'

    SET @CurrentDate = REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,GETDATE(),120)),'-',''),' ','_'),':','')

    SET @CurrentDirectory = @Directory + '\' + @InstanceName + '\' + @CurrentDatabaseFS + '\' + @BackupType

    SET @CurrentFileName = @InstanceName + '_' + @CurrentDatabaseFS + '_' + @BackupType + '_' + @CurrentDate + '.' + @FileExtension

    SET @CurrentFilePath = @CurrentDirectory + '\' + @CurrentFileName

    SET @CurrentCleanupTime = CONVERT(nvarchar(19),(DATEADD(hh,-(@CleanupTime),GETDATE())),126)

    -- Create directory
    SET @CurrentCommand01 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = master.dbo.xp_create_subdir N''' + REPLACE(@CurrentDirectory,'''','''''') + ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'
    EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @CurrentCommand01, '', 1
    SET @Error = @@ERROR
    IF @Error <> 0 SET @CurrentCommandOutput01 = @Error

    -- Perform a backup
    IF @CurrentCommandOutput01 = 0
    BEGIN
      SELECT @CurrentCommand02 = CASE
      WHEN @BackupType = 'FULL' THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabase) + ' TO DISK = ''' + REPLACE(@CurrentFilePath,'''','''''') + ''' WITH CHECKSUM'
      WHEN @BackupType = 'DIFF' THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabase) + ' TO DISK = ''' + REPLACE(@CurrentFilePath,'''','''''') + ''' WITH CHECKSUM, DIFFERENTIAL'
      WHEN @BackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabase) + ' TO DISK = ''' + REPLACE(@CurrentFilePath,'''','''''') + ''' WITH CHECKSUM'
      END
      EXECUTE @CurrentCommandOutput02 = [dbo].[CommandExecute] @CurrentCommand02, '', 1
      SET @Error = @@ERROR
      IF @Error <> 0 SET @CurrentCommandOutput02 = @Error
    END

    -- Verify the backup
    IF @CurrentCommandOutput02 = 0 AND @Verify = 'Y'
    BEGIN
      SET @CurrentCommand03 = 'RESTORE VERIFYONLY FROM DISK = ''' + REPLACE(@CurrentFilePath,'''','''''') + ''' WITH CHECKSUM'
      EXECUTE @CurrentCommandOutput03 = [dbo].[CommandExecute] @CurrentCommand03, '', 1
      SET @Error = @@ERROR
      IF @Error <> 0 SET @CurrentCommandOutput03 = @Error
    END

    -- Delete old backup files
    IF (@CurrentCommandOutput02 = 0 AND @Verify = 'N')
    OR (@CurrentCommandOutput02 = 0 AND @Verify = 'Y' AND @CurrentCommandOutput03 = 0)
    BEGIN
      SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = master.dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectory,'''','''''') + ''', ''' + @FileExtension + ''', ''' + @CurrentCleanupTime + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
      EXECUTE @CurrentCommandOutput04 = [dbo].[CommandExecute] @CurrentCommand04, '', 1
      SET @Error = @@ERROR
      IF @Error <> 0 SET @CurrentCommandOutput04 = @Error
    END

  END

  -- Update that the database is completed
  UPDATE @tmpDatabases
  SET Completed = 1
  WHERE ID = @CurrentID

  -- Clear variables
  SET @CurrentID = NULL
  SET @CurrentDatabase = NULL
  SET @CurrentDatabaseFS = NULL
  SET @CurrentDirectory = NULL
  SET @CurrentDate = NULL
  SET @CurrentFileName = NULL
  SET @CurrentFilePath = NULL
  SET @CurrentCleanupTime = NULL

  SET @CurrentCommand01 = NULL
  SET @CurrentCommand02 = NULL
  SET @CurrentCommand03 = NULL
  SET @CurrentCommand04 = NULL

  SET @CurrentCommandOutput01 = NULL
  SET @CurrentCommandOutput02 = NULL
  SET @CurrentCommandOutput03 = NULL
  SET @CurrentCommandOutput04 = NULL

END

----------------------------------------------------------------------------------------------------
--// Log completing information                                                                 //--
----------------------------------------------------------------------------------------------------

Logging:

SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)

RAISERROR(@EndMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseIntegrityCheck]

@Databases nvarchar(max)

AS

SET NOCOUNT ON

----------------------------------------------------------------------------------------------------
--// Declare variables                                                                          //--
----------------------------------------------------------------------------------------------------

DECLARE @StartMessage nvarchar(max)
DECLARE @EndMessage nvarchar(max)
DECLARE @DatabaseMessage nvarchar(max)
DECLARE @ErrorMessage nvarchar(max)

DECLARE @CurrentID int
DECLARE @CurrentDatabase nvarchar(max)
DECLARE @CurrentCommand01 nvarchar(max)
DECLARE @CurrentCommandOutput01 int

DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                             DatabaseName nvarchar(max),
                             Completed bit)

DECLARE @Error int

SET @Error = 0

----------------------------------------------------------------------------------------------------
--// Log initial information                                                                    //--
----------------------------------------------------------------------------------------------------

SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10)

RAISERROR(@StartMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
--// Select databases                                                                           //--
----------------------------------------------------------------------------------------------------

IF @Databases IS NULL OR @Databases = ''
BEGIN
  SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

INSERT INTO @tmpDatabases (DatabaseName, Completed)
SELECT DatabaseName AS DatabaseName,
       0 AS Completed
FROM dbo.DatabaseSelect (@Databases)
ORDER BY DatabaseName ASC

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
BEGIN
  SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check error variable                                                                       //--
----------------------------------------------------------------------------------------------------

IF @Error <> 0 GOTO Logging

----------------------------------------------------------------------------------------------------
--// Execute commands                                                                           //--
----------------------------------------------------------------------------------------------------

WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
BEGIN

  SELECT TOP 1 @CurrentID = ID,
               @CurrentDatabase = DatabaseName
  FROM @tmpDatabases
  WHERE Completed = 0
  ORDER BY ID ASC

  -- Set database message
  SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabase) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabase,'status') AS nvarchar) + CHAR(13) + CHAR(10)
  RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

  IF DATABASEPROPERTYEX(@CurrentDatabase,'status') = 'ONLINE'
  BEGIN
    SET @CurrentCommand01 = 'DBCC CHECKDB (' + QUOTENAME(@CurrentDatabase) + ') WITH DATA_PURITY, NO_INFOMSGS'
    EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @CurrentCommand01, '', 1
    SET @Error = @@ERROR
    IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
  END

  -- Update that the database is completed
  UPDATE @tmpDatabases
  SET Completed = 1
  WHERE ID = @CurrentID

  -- Clear variables
  SET @CurrentID = NULL
  SET @CurrentDatabase = NULL
  SET @CurrentCommand01 = NULL
  SET @CurrentCommandOutput01 = NULL

END

----------------------------------------------------------------------------------------------------
--// Log completing information                                                                 //--
----------------------------------------------------------------------------------------------------

Logging:

SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)

RAISERROR(@EndMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IndexOptimize]

@Databases nvarchar(max),
@FragmentationHigh_LOB nvarchar(max) = 'INDEX_REBUILD_OFFLINE',
@FragmentationHigh_NonLOB nvarchar(max) = 'INDEX_REBUILD_OFFLINE',
@FragmentationMedium_LOB nvarchar(max) = 'INDEX_REORGANIZE',
@FragmentationMedium_NonLOB nvarchar(max) = 'INDEX_REORGANIZE',
@FragmentationLow_LOB nvarchar(max) = 'NOTHING',
@FragmentationLow_NonLOB nvarchar(max) = 'NOTHING',
@FragmentationLevel1 tinyint = 5,
@FragmentationLevel2 tinyint = 30,
@PageCountLevel int = 1000

AS

SET NOCOUNT ON

SET LOCK_TIMEOUT 3600000

----------------------------------------------------------------------------------------------------
--// Declare variables                                                                          //--
----------------------------------------------------------------------------------------------------

DECLARE @StartMessage nvarchar(max)
DECLARE @EndMessage nvarchar(max)
DECLARE @DatabaseMessage nvarchar(max)
DECLARE @ErrorMessage nvarchar(max)

DECLARE @CurrentID int
DECLARE @CurrentDatabase nvarchar(max)

DECLARE @CurrentCommandSelect01 nvarchar(max)
DECLARE @CurrentCommandSelect02 nvarchar(max)
DECLARE @CurrentCommandSelect03 nvarchar(max)

DECLARE @CurrentCommand01 nvarchar(max)
DECLARE @CurrentCommand02 nvarchar(max)

DECLARE @CurrentCommandOutput01 int
DECLARE @CurrentCommandOutput02 int

DECLARE @CurrentIxID int
DECLARE @CurrentSchemaID int
DECLARE @CurrentSchemaName nvarchar(max)
DECLARE @CurrentObjectID int
DECLARE @CurrentObjectName nvarchar(max)
DECLARE @CurrentIndexID int
DECLARE @CurrentIndexName nvarchar(max)
DECLARE @CurrentIndexType int
DECLARE @CurrentIndexExists bit
DECLARE @CurrentIsLOB bit
DECLARE @CurrentFragmentationLevel float
DECLARE @CurrentPageCount bigint
DECLARE @CurrentAction nvarchar(max)
DECLARE @CurrentComment nvarchar(max)

DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                             DatabaseName nvarchar(max),
                             Completed bit)

DECLARE @tmpIndexes TABLE (IxID int IDENTITY PRIMARY KEY,
                           SchemaID int,
                           SchemaName nvarchar(max),
                           ObjectID int,
                           ObjectName nvarchar(max),
                           IndexID int,
                           IndexName nvarchar(max),
                           IndexType int,
                           Completed bit)

DECLARE @tmpIndexExists TABLE ([Count] int)

DECLARE @tmpIsLOB TABLE ([Count] int)

DECLARE @Actions TABLE ([Action] nvarchar(max))

INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')
INSERT INTO @Actions([Action]) VALUES('STATISTICS_UPDATE')
INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE_STATISTICS_UPDATE')
INSERT INTO @Actions([Action]) VALUES('NOTHING')

DECLARE @Error int

SET @Error = 0

----------------------------------------------------------------------------------------------------
--// Log initial information                                                                    //--
----------------------------------------------------------------------------------------------------

SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationHigh_LOB = ' + ISNULL('''' + REPLACE(@FragmentationHigh_LOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationHigh_NonLOB = ' + ISNULL('''' + REPLACE(@FragmentationHigh_NonLOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationMedium_LOB = ' + ISNULL('''' + REPLACE(@FragmentationMedium_LOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationMedium_NonLOB = ' + ISNULL('''' + REPLACE(@FragmentationMedium_NonLOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationLow_LOB = ' + ISNULL('''' + REPLACE(@FragmentationLow_LOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationLow_NonLOB = ' + ISNULL('''' + REPLACE(@FragmentationLow_NonLOB,'''','''''') + '''','NULL')
SET @StartMessage = @StartMessage + ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
SET @StartMessage = @StartMessage + ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
SET @StartMessage = @StartMessage + ', @PageCountLevel = ' + ISNULL(CAST(@PageCountLevel AS nvarchar),'NULL')
SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10)

RAISERROR(@StartMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
--// Select databases                                                                           //--
----------------------------------------------------------------------------------------------------

IF @Databases IS NULL OR @Databases = ''
BEGIN
  SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

INSERT INTO @tmpDatabases (DatabaseName, Completed)
SELECT DatabaseName AS DatabaseName,
       0 AS Completed
FROM dbo.DatabaseSelect (@Databases)
ORDER BY DatabaseName ASC

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
BEGIN
  SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check input parameters                                                                     //--
----------------------------------------------------------------------------------------------------

IF @FragmentationHigh_LOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE')
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationHigh_LOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationHigh_NonLOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE' OR SERVERPROPERTY('EngineEdition') = 3)
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationHigh_NonLOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationMedium_LOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE')
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationMedium_LOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationMedium_NonLOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE' OR SERVERPROPERTY('EngineEdition') = 3)
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationMedium_NonLOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationLow_LOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE')
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationLow_LOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationLow_NonLOB NOT IN(SELECT [Action] FROM @Actions WHERE [Action] <> 'INDEX_REBUILD_ONLINE' OR SERVERPROPERTY('EngineEdition') = 3)
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationLow_NonLOB is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 >= @FragmentationLevel2 OR @FragmentationLevel1 IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationLevel1 is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 <= @FragmentationLevel1 OR @FragmentationLevel2 IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @FragmentationLevel2 is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

IF @PageCountLevel < 0 OR @PageCountLevel IS NULL
BEGIN
  SET @ErrorMessage = 'The value for parameter @PageCountLevel is not supported.' + CHAR(13) + CHAR(10)
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
  SET @Error = @@ERROR
END

----------------------------------------------------------------------------------------------------
--// Check error variable                                                                       //--
----------------------------------------------------------------------------------------------------

IF @Error <> 0 GOTO Logging

----------------------------------------------------------------------------------------------------
--// Execute commands                                                                           //--
----------------------------------------------------------------------------------------------------

WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
BEGIN

  SELECT TOP 1 @CurrentID = ID,
               @CurrentDatabase = DatabaseName
  FROM @tmpDatabases
  WHERE Completed = 0
  ORDER BY ID ASC

  -- Set database message
  SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabase) + CHAR(13) + CHAR(10)
  SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabase,'status') AS nvarchar) + CHAR(13) + CHAR(10)
  RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

  IF DATABASEPROPERTYEX(@CurrentDatabase,'status') = 'ONLINE'
  BEGIN

    -- Select indexes in the current database
    SET @CurrentCommandSelect01 = 'SELECT ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[schema_id], ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[name], ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[object_id], ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[name], ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.index_id, ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[name], ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[type], 0 FROM ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.objects ON ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[object_id] = ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas ON ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[schema_id] = ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[schema_id] WHERE ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.type = ''U'' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.is_ms_shipped = 0 AND ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[type] IN(1,2) ORDER BY ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[schema_id] ASC, ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[object_id] ASC, ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.index_id ASC'

    INSERT INTO @tmpIndexes (SchemaID, SchemaName, ObjectID, ObjectName, IndexID, IndexName, IndexType, Completed)
    EXECUTE(@CurrentCommandSelect01)

    WHILE EXISTS (SELECT * FROM @tmpIndexes WHERE Completed = 0)
    BEGIN

      SELECT TOP 1 @CurrentIxID = IxID,
                   @CurrentSchemaID = SchemaID,
                   @CurrentSchemaName = SchemaName,
                   @CurrentObjectID = ObjectID,
                   @CurrentObjectName = ObjectName,
                   @CurrentIndexID = IndexID,
                   @CurrentIndexName = IndexName,
                   @CurrentIndexType = IndexType
      FROM @tmpIndexes
      WHERE Completed = 0
      ORDER BY IxID ASC

      -- Does the index exist?
      SET @CurrentCommandSelect02 = 'SELECT COUNT(*) FROM ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.objects ON ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[object_id] = ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas ON ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[schema_id] = ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[schema_id] WHERE ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.type = ''U'' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.index_id > 0 AND ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[schema_id] = ' + CAST(@CurrentSchemaID AS nvarchar) + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.schemas.[name] = N' + QUOTENAME(@CurrentSchemaName,'''') + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[object_id] = ' + CAST(@CurrentObjectID AS nvarchar) + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.objects.[name] = N' + QUOTENAME(@CurrentObjectName,'''') + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.index_id = ' + CAST(@CurrentIndexID AS nvarchar) + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[name] = N' + QUOTENAME(@CurrentIndexName,'''') + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.indexes.[type] = ' + CAST(@CurrentIndexType AS nvarchar)

      INSERT INTO @tmpIndexExists ([Count])
      EXECUTE(@CurrentCommandSelect02)

      IF (SELECT [Count] FROM @tmpIndexExists) > 0 BEGIN SET @CurrentIndexExists = 1 END ELSE BEGIN SET @CurrentIndexExists = 0 END

      IF @CurrentIndexExists = 0 GOTO NoAction

      -- Does the index contain a LOB?
      IF @CurrentIndexType = 1 SET @CurrentCommandSelect03 = 'SELECT COUNT(*) FROM ' + QUOTENAME(@CurrentDatabase) + '.sys.columns INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.types ON ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.system_type_id = ' + QUOTENAME(@CurrentDatabase) + '.sys.types.user_type_id WHERE ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.[object_id] = ' + CAST(@CurrentObjectID AS nvarchar) + ' AND (' + QUOTENAME(@CurrentDatabase) + '.sys.types.name IN(''xml'',''image'',''text'',''ntext'') OR (' + QUOTENAME(@CurrentDatabase) + '.sys.types.name IN(''varchar'',''nvarchar'',''varbinary'') AND ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.max_length = -1))'
      IF @CurrentIndexType = 2 SET @CurrentCommandSelect03 = 'SELECT COUNT(*) FROM ' + QUOTENAME(@CurrentDatabase) + '.sys.index_columns INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.columns ON ' + QUOTENAME(@CurrentDatabase) + '.sys.index_columns.[object_id] = ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.[object_id] AND ' + QUOTENAME(@CurrentDatabase) + '.sys.index_columns.column_id = ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.column_id INNER JOIN ' + QUOTENAME(@CurrentDatabase) + '.sys.types ON ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.system_type_id = ' + QUOTENAME(@CurrentDatabase) + '.sys.types.user_type_id WHERE ' + QUOTENAME(@CurrentDatabase) + '.sys.index_columns.[object_id] = ' + CAST(@CurrentObjectID AS nvarchar) + ' AND ' + QUOTENAME(@CurrentDatabase) + '.sys.index_columns.index_id = ' + CAST(@CurrentIndexID AS nvarchar) + ' AND (' + QUOTENAME(@CurrentDatabase) + '.sys.types.[name] IN(''xml'',''image'',''text'',''ntext'') OR (' + QUOTENAME(@CurrentDatabase) + '.sys.types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND ' + QUOTENAME(@CurrentDatabase) + '.sys.columns.max_length = -1))'

      INSERT INTO @tmpIsLOB ([Count])
      EXECUTE(@CurrentCommandSelect03)

      IF (SELECT [Count] FROM @tmpIsLOB) > 0 BEGIN SET @CurrentIsLOB = 1 END ELSE BEGIN SET @CurrentIsLOB = 0 END

      -- Is the index fragmented?
      SELECT @CurrentFragmentationLevel = avg_fragmentation_in_percent,
             @CurrentPageCount = page_count
      FROM sys.dm_db_index_physical_stats(DB_ID(@CurrentDatabase), @CurrentObjectID, @CurrentIndexID, NULL, 'LIMITED')
      WHERE alloc_unit_type_desc = 'IN_ROW_DATA'
      AND index_level = 0
      ORDER BY partition_number ASC
      SET @Error = @@ERROR
      IF @Error = 1222
      BEGIN
        SET @ErrorMessage = 'The object sys.dm_db_index_physical_stats is locked for the index ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + '.' + QUOTENAME(@CurrentIndexName) + '.' + CHAR(13) + CHAR(10)
        RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
        GOTO NoAction
      END

      -- Decide action
      SELECT @CurrentAction = CASE
      WHEN @CurrentIsLOB = 1 AND @CurrentFragmentationLevel >= @FragmentationLevel2 AND @CurrentPageCount >= @PageCountLevel THEN @FragmentationHigh_LOB
      WHEN @CurrentIsLOB = 0 AND @CurrentFragmentationLevel >= @FragmentationLevel2 AND @CurrentPageCount >= @PageCountLevel THEN @FragmentationHigh_NonLOB
      WHEN @CurrentIsLOB = 1 AND @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 AND @CurrentPageCount >= @PageCountLevel THEN @FragmentationMedium_LOB
      WHEN @CurrentIsLOB = 0 AND @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 AND @CurrentPageCount >= @PageCountLevel THEN @FragmentationMedium_NonLOB
      WHEN @CurrentIsLOB = 1 AND (@CurrentFragmentationLevel < @FragmentationLevel1 OR @CurrentPageCount < @PageCountLevel) THEN @FragmentationLow_LOB
      WHEN @CurrentIsLOB = 0 AND (@CurrentFragmentationLevel < @FragmentationLevel1 OR @CurrentPageCount < @PageCountLevel) THEN @FragmentationLow_NonLOB
      END

      -- Create comment
      SET @CurrentComment = 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' ELSE 'N/A' END + ', '
      SET @CurrentComment = @CurrentComment + 'LOB: ' + CASE WHEN @CurrentIsLOB = 1 THEN 'Yes' WHEN @CurrentIsLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
      SET @CurrentComment = @CurrentComment + 'PageCount: ' + CAST(@CurrentPageCount AS nvarchar) + ', '
      SET @CurrentComment = @CurrentComment + 'Fragmentation: ' + CAST(@CurrentFragmentationLevel AS nvarchar)

      IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE','INDEX_REORGANIZE','INDEX_REORGANIZE_STATISTICS_UPDATE')
      BEGIN
        SELECT @CurrentCommand01 = CASE
        WHEN @CurrentAction = 'INDEX_REBUILD_ONLINE' THEN 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentDatabase) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = ON)'
        WHEN @CurrentAction = 'INDEX_REBUILD_OFFLINE' THEN 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentDatabase) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = OFF)'
        WHEN @CurrentAction IN('INDEX_REORGANIZE','INDEX_REORGANIZE_STATISTICS_UPDATE') THEN 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentDatabase) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' REORGANIZE'
        END
        EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @CurrentCommand01, @CurrentComment, 2
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
      END

      IF @CurrentAction IN('INDEX_REORGANIZE_STATISTICS_UPDATE','STATISTICS_UPDATE')
      BEGIN
        SET @CurrentCommand02 = 'UPDATE STATISTICS ' + QUOTENAME(@CurrentDatabase) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentIndexName)
        EXECUTE @CurrentCommandOutput02 = [dbo].[CommandExecute] @CurrentCommand02, '', 2
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput02 = @Error
      END

      NoAction:

      -- Update that the index is completed
      UPDATE @tmpIndexes
      SET Completed = 1
      WHERE IxID = @CurrentIxID

      -- Clear variables
      SET @CurrentCommandSelect02 = NULL
      SET @CurrentCommandSelect03 = NULL

      SET @CurrentCommand01 = NULL
      SET @CurrentCommand02 = NULL

      SET @CurrentCommandOutput01 = NULL
      SET @CurrentCommandOutput02 = NULL

      SET @CurrentIxID = NULL
      SET @CurrentSchemaID = NULL
      SET @CurrentSchemaName = NULL
      SET @CurrentObjectID = NULL
      SET @CurrentObjectName = NULL
      SET @CurrentIndexID = NULL
      SET @CurrentIndexName = NULL
      SET @CurrentIndexType = NULL
      SET @CurrentIndexExists = NULL
      SET @CurrentIsLOB = NULL
      SET @CurrentFragmentationLevel = NULL
      SET @CurrentPageCount = NULL
      SET @CurrentAction = NULL
      SET @CurrentComment = NULL

      DELETE FROM @tmpIndexExists
      DELETE FROM @tmpIsLOB

    END

  END

  -- Update that the database is completed
  UPDATE @tmpDatabases
  SET Completed = 1
  WHERE ID = @CurrentID

  -- Clear variables
  SET @CurrentID = NULL
  SET @CurrentDatabase = NULL

  SET @CurrentCommandSelect01 = NULL

  DELETE FROM @tmpIndexes

END

----------------------------------------------------------------------------------------------------
--// Log completing information                                                                 //--
----------------------------------------------------------------------------------------------------

Logging:

SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)

RAISERROR(@EndMessage,10,1) WITH NOWAIT

----------------------------------------------------------------------------------------------------
GO

IF (SELECT CAST([Value] AS nvarchar) FROM #Config WHERE Name = 'Error') <> '0' OR (SELECT [Value] FROM #Config WHERE Name = 'Jobs') <> 'Y'
BEGIN
  RETURN
END

DECLARE @LogDirectory nvarchar(max)
DECLARE @BackupDirectory nvarchar(max)
DECLARE @Database nvarchar(max)
DECLARE @OutputFile nvarchar(max)

DECLARE @JobName01 nvarchar(max)
DECLARE @JobName02 nvarchar(max)
DECLARE @JobName03 nvarchar(max)
DECLARE @JobName04 nvarchar(max)
DECLARE @JobName05 nvarchar(max)
DECLARE @JobName06 nvarchar(max)
DECLARE @JobName07 nvarchar(max)

DECLARE @JobCommand01 nvarchar(max)
DECLARE @JobCommand02 nvarchar(max)
DECLARE @JobCommand03 nvarchar(max)
DECLARE @JobCommand04 nvarchar(max)
DECLARE @JobCommand05 nvarchar(max)
DECLARE @JobCommand06 nvarchar(max)
DECLARE @JobCommand07 nvarchar(max)

SELECT @LogDirectory = Value 
FROM #Config
WHERE [Name] = 'LogDirectory'

SELECT @BackupDirectory = Value 
FROM #Config
WHERE [Name] = 'BackupDirectory'

SELECT @Database = Value 
FROM #Config
WHERE [Name] = 'Database'

SET @OutputFile = @LogDirectory + '\SQLAGENT_JOB_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt'

SET @JobName01 = 'DatabaseBackup - SYSTEM_DATABASES - FULL'
SET @JobCommand01 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''SYSTEM_DATABASES'', @Directory = N''' + REPLACE(@BackupDirectory,'''','''''') +  ''', @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = 24" -b'

SET @JobName02 = 'DatabaseBackup - USER_DATABASES - DIFF'
SET @JobCommand02 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = N''' + REPLACE(@BackupDirectory,'''','''''') +  ''', @BackupType = ''DIFF'', @Verify = ''Y'', @CleanupTime = 24" -b'

SET @JobName03 = 'DatabaseBackup - USER_DATABASES - FULL'
SET @JobCommand03 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = N''' + REPLACE(@BackupDirectory,'''','''''') +  ''', @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = 24" -b'

SET @JobName04 = 'DatabaseBackup - USER_DATABASES - LOG'
SET @JobCommand04 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = N''' + REPLACE(@BackupDirectory,'''','''''') +  ''', @BackupType = ''LOG'', @Verify = ''Y'', @CleanupTime = 24" -b'

SET @JobName05 = 'DatabaseIntegrityCheck - SYSTEM_DATABASES'
SET @JobCommand05 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseIntegrityCheck] @Databases = ''SYSTEM_DATABASES''" -b'

SET @JobName06 = 'DatabaseIntegrityCheck - USER_DATABASES'
SET @JobCommand06 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[DatabaseIntegrityCheck] @Databases = ''USER_DATABASES''" -b'

SET @JobName07 = 'IndexOptimize - USER_DATABASES'
IF SERVERPROPERTY('EngineEdition') = 3
BEGIN
  SET @JobCommand07 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[IndexOptimize] @Databases = ''USER_DATABASES'', @FragmentationHigh_NonLOB = ''INDEX_REBUILD_ONLINE''" -b'
END
ELSE
BEGIN
  SET @JobCommand07 = 'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d ' + @Database + ' -Q "EXECUTE [dbo].[IndexOptimize] @Databases = ''USER_DATABASES''" -b'  
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName01)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName01
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName01, @step_name = @JobName01, @subsystem = 'CMDEXEC', @command = @JobCommand01, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName01
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName02)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName02
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName02, @step_name = @JobName02, @subsystem = 'CMDEXEC', @command = @JobCommand02, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName02
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName03)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName03
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName03, @step_name = @JobName03, @subsystem = 'CMDEXEC', @command = @JobCommand03, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName03
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName04)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName04
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName04, @step_name = @JobName04, @subsystem = 'CMDEXEC', @command = @JobCommand04, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName04
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName05)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName05
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName05, @step_name = @JobName05, @subsystem = 'CMDEXEC', @command = @JobCommand05, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName05
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName06)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName06
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName06, @step_name = @JobName06, @subsystem = 'CMDEXEC', @command = @JobCommand06, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName06
END

IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName07)
BEGIN
  EXECUTE msdb.dbo.sp_add_job @job_name = @JobName07
  EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName07, @step_name = @JobName07, @subsystem = 'CMDEXEC', @command = @JobCommand07, @output_file_name = @OutputFile
  EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName07
END
GO
