
/*******************************
Author:         Eric Austin - https://github.com/austineric/SimpleSQLServerSourceControl
Create date:    November 2018
*******************************/

--run these queries manually to ensure objects of the same name do not already exist in the database
IF EXISTS (SELECT * FROM sys.tables WHERE name='SourceControl') 
    PRINT 'Warning: a table named SourceControl already exists in this database.'
    ELSE PRINT 'Okay to proceed with SourceControl table creation.'

IF EXISTS (SELECT * FROM sys.triggers WHERE name='SourceControlTrigger') 
    PRINT 'Warning: a trigger named SourceControlTrigger already exists in this database.'
    ELSE PRINT 'Okay to proceed with SourceControlTrigger creation.'


--create source control table
CREATE TABLE dbo.SourceControl
    (
    RowID INT IDENTITY(1,1)
    ,EventTimestamp DATETIME
    ,[Server] VARCHAR(255)
    ,[Database] VARCHAR(255)
    ,[User] VARCHAR(255)
    ,ObjectName VARCHAR(255)
    ,ObjectType VARCHAR(255)
    ,[Action] VARCHAR(255)
    ,[Definition] VARCHAR(MAX)
    );
    
ALTER TABLE SourceControl ADD CONSTRAINT PK_SourceControl_RowID PRIMARY KEY CLUSTERED (RowID);
GO

--create source control trigger
CREATE TRIGGER SourceControlTrigger ON DATABASE
FOR
    CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE
    ,CREATE_VIEW, ALTER_VIEW, DROP_VIEW
    ,CREATE_TABLE, ALTER_TABLE, DROP_TABLE
    ,CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION
    ,CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER
    ,CREATE_INDEX, ALTER_INDEX, DROP_INDEX

AS
SET NOCOUNT ON;
BEGIN
    
DECLARE @data XML
DECLARE @eventtimestamp DATETIME
DECLARE @server VARCHAR(255)
DECLARE @database VARCHAR(255)
DECLARE @user VARCHAR(255)
DECLARE @objectname VARCHAR(255)
DECLARE @objecttype VARCHAR(255)
DECLARE @action VARCHAR(255)
DECLARE @definition VARCHAR(MAX)

SET @data=EVENTDATA()
SET @eventtimestamp=GETDATE()
SET @server=@data.value('(/EVENT_INSTANCE/ServerName)[1]', 'VARCHAR(255)')
SET @database=@data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'VARCHAR(255)')
SET @user=@data.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(255)')
SET @objectname=@data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(255)')
SET @objecttype=@data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'VARCHAR(255)')
SET @action=@data.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(255)')
SET @definition=@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'VARCHAR(MAX)')

BEGIN
    INSERT INTO SourceControl 
        (
        EventTimestamp
        ,[Server]
        ,[Database]
        ,[User]
        ,ObjectName
        ,ObjectType
        ,[Action]
        ,[Definition]
        )
    VALUES
        (
        @eventtimestamp
        ,@server
        ,@database
        ,@user
        ,@objectname
        ,@objecttype
        ,@action
        ,@definition
        )
END;

END;
