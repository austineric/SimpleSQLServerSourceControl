

/*******************************
Author:         Eric Austin - https://github.com/austineric/SimpleSQLServerSourceControl
Create date:    November 2018
Description:    Create table used in SimpleSQLSourceControl system

This table should be created in either:
    -an existing database (for if source control is and will be used on only that one database)
    -a specifically designated database (for if source control will be used on multiple databases on the same SQL Server instance)
        -CREATE DATABASE SourceControlDb then table gets created inside database
Note: SSSSC should not be used across multiple SQL Server instances
*******************************/

--ensure desired database is being used
PRINT 'Make sure this is the database you want to create the table in: ' + DB_NAME()

--check to ensure an object of the same name does not already exist in the database
IF EXISTS (SELECT * FROM sys.tables WHERE name='SourceControl') 
    PRINT 'Warning: a table named SourceControl already exists in this database.'
    ELSE PRINT 'Okay to proceed with SourceControl table creation.'

--exit to ensure table creation doesn't happen inadvertantly before above checks are run 
RETURN;

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

