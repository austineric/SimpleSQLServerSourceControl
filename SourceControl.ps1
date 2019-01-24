
$location=(Get-Location).Path

Clear-Host

Write-Host ""
Write-Host "--------------------------------------------------------------------------------------------"
Write-Host ( "SimpleSQLServerSourceControl - https://github.com/austineric/SimpleSQLServerSourceControl" )
Write-Host "--------------------------------------------------------------------------------------------"
Write-Host ""
Write-Host "Running..."

#retrieve list of servers and databases from ServersAndDatabases.txt
$sourcelist=@(Import-Csv -LiteralPath ".\ServersAndDatabases.txt")

#notify and exit if no servers and databases have been added
If ($sourcelist.Count -eq 0) {
    Write-Host ""
    Write-Host "Please add server and database names to $location\ServersAndDatabases.txt"
    Write-Host ""
    Write-Host "Exiting now"
    Write-Host ""
    Pause
    Exit
    }

#loop through data sources
$sourcelist | ForEach {
    
    $servername=$_.Server
    $databasename=$_.Database

    #build query
    $eventquery="SELECT [RowID], [EventTimestamp], [Server], [Database], [User], [ObjectName], [ObjectType], [Action], '$databasename' AS 'SourceControlDatabase' FROM SourceControl ORDER BY RowID DESC;"

    $data+=@(Invoke-Sqlcmd $eventquery -ServerInstance $servername -Database $databasename -MaxCharLength 100000 )

    }

#check if destination directory exists and create it if it does not
[boolean]$destination=Test-Path -Path ".\DefinitionFiles"
If ($destination -eq 0) {New-Item -ItemType Directory -Path ".\DefinitionFiles"}

#remove previous files
Remove-Item ".\DefinitionFiles\*"

#display sourcecontrol results for user selection
($data | Out-GridView -OutputMode Multiple -Title "Choose two rows") | Sort-Object -Property RowID | ForEach {
    
    $filepath=".\DefinitionFiles\" + $_.RowID + ".txt"

    $definitionquery="SELECT [Definition] FROM SourceControl WHERE RowID=" +$_.RowID
    (Invoke-Sqlcmd $definitionquery -ServerInstance $_.Server -Database $_.SourceControlDatabase -MaxCharLength 100000).Definition | Out-File -FilePath $filepath

    Start Notepad++ $filepath
    }
