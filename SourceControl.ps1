
$location=(Get-Location).Path

#retrieve list of servers and databases from ServersAndDatabases.txt
$sourcelist=(Import-Csv -LiteralPath ".\ServersAndDatabases.txt")

#notify and exit if no servers and databases have been added
If ($sourcelist.Count -eq 0) {
    Clear-Host
    Write-Host "Please add server and database names to $location\ServersAndDatabases.txt"
    Write-Host "Exiting now"
    Pause
    Exit
}

#if there are single values set the variables to those values
If (($sourcelist | Measure-Object).Count -eq 1) {$servername=$sourcelist.Server; $databasename=$sourcelist.Database}

#if there are multiple servers and databases display a list to choose from
If (($sourcelist | Measure-Object).Count -gt 1) {
$sourcelist | Out-GridView -OutputMode Single -Title "Choose a data source" | ForEach {
    $servername=$_.Server
    $databasename=$_.Database
    }
}

#exit if no server selected
If ($servername -eq "" -and $databasename -eq "") {
    Clear-Host
    Write-Host "No data source selected. Exiting now."
    Pause
    Exit
}

Clear-Host

#remove previous files
Remove-Item ".\*.txt" -Exclude "ServersAndDatabases.txt"

#get data from source control table
$eventquery="SELECT [RowID], [EventTimestamp], [Server], [Database], [User], [ObjectName], [ObjectType], [Action] FROM SourceControl ORDER BY RowID DESC;"
#$sqlcommand

(Invoke-Sqlcmd $eventquery -ServerInstance $servername -Database $databasename -MaxCharLength 100000 | Out-GridView -OutputMode Multiple -Title "Choose two rows").RowID |
Sort-Object -Property [0] | ForEach {
    $filepath=".\" + $_ + ".txt"

    $definitionquery="SELECT [Definition] FROM SourceControl WHERE RowID=" + $_
    (Invoke-Sqlcmd $definitionquery -ServerInstance $servername -Database $databasename -MaxCharLength 100000).Definition | Out-File -FilePath $filepath

    Start Notepad++ $filepath
}
