
$sourcelist=New-Object System.Data.DataTable
$sourcelist.Columns.Add("Server")
$sourcelist.Columns.Add("Database")

#****** MANUALLY ADD SERVERS AND DATABASES HERE ******#
#example: $sourcelist.Rows.Add("ServerName","DatabaseName")
$sourcelist.Rows.Add("","")

If ($sourcelist.Server -eq "" -and $sourcelist.Database -eq "") {
    Clear-Host
    Write-Host "Please add server and database names in the SourceControl.ps1 script located at" (Get-Location).Path
    Write-Host "Exiting now."
    Pause
    Exit
}

#if there are single values in the array set the variables to those values
If ($sourcelist.Rows.Count -eq 1) {$servername=$sourcelist.Server; $databasename=$sourcelist.Database}

#if there are multiple servers and databases display a list to choose from
If ($sourcelist.Rows.Count -gt 1) {
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

#remove previous files
Remove-Item ".\*.txt"

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
