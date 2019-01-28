

/*******************************
Author:         Eric Austin - https://github.com/austineric/SimpleSQLServerSourceControl
Create date:    January 2019
Description:     Return source control data 

This proc should be created in whatever database the SourceControl table was created in
*******************************/

--ensure desired database is being used
PRINT 'Make sure this is the database you want to create the proc in: ' + DB_NAME()

--check to ensure an object of the same name does not already exist in the database
IF EXISTS (SELECT * FROM sys.objects WHERE name='SourceControlProc') 
    PRINT 'Warning: an object named SourceControlProc already exists in this database.'
    ELSE PRINT 'Okay to proceed with SourceControlProc creation.'

--exit to ensure proc creation doesn't happen inadvertantly before above checks are run 
RETURN;

--create source control proc
--(SSMS may be warning that 'CREATE PROCEDURE' must be the only statement in the batch; just run the CREATE PROCEDURE statement separately from the above statements)

-- =============================================
-- Author:          Eric Austin
-- Create date:     January 2019
-- Description:     Return source control data 
-- =============================================
CREATE PROCEDURE SourceControlProc

AS
BEGIN

SET NOCOUNT ON;

SELECT 
    RowID
    ,EventTimestamp
    ,[Server]
    ,[Database]
    ,[User]
    ,ObjectName
    ,ObjectType
    ,[Action]
    ,DB_NAME() AS 'SourceControlDatabase'
FROM dbo.SourceControl
ORDER BY EventTimestamp DESC, RowID DESC;

END
