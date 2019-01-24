

/*******************************
Author:         Eric Austin - https://github.com/austineric/SimpleSQLServerSourceControl
Create date:    November 2018
Description:    Create trigger used in SimpleSQLSourceControl system

This trigger should be created in any database where source control should be used

IMPORTANT: if you have created the SourceControl table in a different database than the one where the trigger will reside,
you must go to the "INSERT INTO SourceControl" statement below and change it to "INSERT INTO DatabaseName.SchemaName.SourceControl"
*******************************/

--ensure desired database is being used
PRINT 'Make sure this is the database you want to create the trigger in: ' + DB_NAME()

--check to ensure a trigger of the same name does not already exist in the database
IF EXISTS (SELECT * FROM sys.triggers WHERE name='SourceControlTrigger') 
    PRINT 'Warning: a trigger named SourceControlTrigger already exists in this database.'
    ELSE PRINT 'Okay to proceed with SourceControlTrigger creation.'

--exit to ensure the above statements are run before the trigger creation statement below
RETURN;

--create source control trigger 
--(SSMS may be warning that 'CREATE TRIGGER' must be the only statement in the batch; just run the CREATE TRIGGER statement separately from the above statements)
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
