
$location=(Get-Location).Path

#remove previous files
Remove-Item ".\*.txt" -Exclude "ServersAndDatabases.txt"

#retrieve list of servers and databases from ServersAndDatabases.txt
$sourcelist=@(Import-Csv -LiteralPath ".\ServersAndDatabases.txt")

#notify and exit if no servers and databases have been added
If ($sourcelist.Count -eq 0) {
    Clear-Host
    Write-Host "Please add server and database names to $location\ServersAndDatabases.txt"
    Write-Host "Exiting now"
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

#display sourcecontrol results for user selection
($data | Out-GridView -OutputMode Multiple -Title "Choose two rows") | Sort-Object -Property [0] | ForEach {
    
    $filepath=".\" + $_.RowID + ".txt"

    $definitionquery="SELECT [Definition] FROM SourceControl WHERE RowID=" +$_.RowID
    (Invoke-Sqlcmd $definitionquery -ServerInstance $_.Server -Database $_.SourceControlDatabase -MaxCharLength 100000).Definition | Out-File -FilePath $filepath

    Start Notepad++ $filepath
    }
