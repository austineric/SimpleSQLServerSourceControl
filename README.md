# SimpleSQLServerSourceControl

## Installation
(Designed to work with Notepad++ <https://notepad-plus-plus.org/>)
<br>
<br>
1. Clone repo to local directory **or** download and extract zip file from Github to a location on your computer (ie Documents)
2. Open and run SqlScript.sql within the SQL Server database of your choosing (can be run on multiple databases/servers)
3. Open ServersAndDatabases.txt and enter the server name/s and database name/s the SQL script was run on (use the following format, note that the first line is a header line and should be left alone): ![](https://github.com/austineric/Images/blob/master/SimpleSQLServerSourceControl/ServersAndDatabasesExample.png?raw=true)
4. Installation is complete

## Usage
1. Double-click SourceControl.bat
2. If you have entered more than one server and database into ServersAndDatabase.txt you will be presented with a list to choose from, if only one has been entered then it will be used automatically
3. You will be presented with a list of rows from the SourceControl table from which one or more rows can be selected (use Control or Shift to select multiple rows, you can also filter the list using the Filter bar at the top)
4. After clicking "OK" each file that was selected is opened in a separate tab in Notepad++
5. The event definition can be used for reverting to a previous version of an object or, if the Compare plugin is installed, for comparing changes between versions (see below for Compare plugin installation instructions)

### Installing Compare Plugin
1.  Download the Compare plugin zip file from <https://github.com/pnedev/compare-plugin/releases>
2. Extract zip file into a location on your computer
3. Copy file contents (ie ComparePlugin.dll and ComparePlugin subfolder) into C:\Program Files\Notepad++\plugins
4. Go to Notepad++ Settings > Import > Import plugin(s), navigate to C:\Program Files\Notepad++\plugins, and select ComparePlugin.dll
5. Notepad++ will require a restart
6. Now after running SourceControl.bat you can run the compare plugin: ![](https://github.com/austineric/Images/blob/master/SimpleSQLServerSourceControl/CompareMenu.png?raw=true)
7. Which will allow you to see changes between versions: ![](https://github.com/austineric/Images/blob/master/SimpleSQLServerSourceControl/Compare.png?raw=true)






