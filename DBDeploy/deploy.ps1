param ([string]$myenv = "Development")
$scriptpath = $MyInvocation.MyCommand.Path
$appPath = Split-Path $scriptpath
$path = Get-Location
$location = Set-Location $path
$filebefore =  resolve-path "$appPath\deployment_schema_before.sql"
$fileafter = resolve-path "$appPath\deployment_schema_after.sql"
$sqlpath = resolve-path "$path\sql_order.xml"
$transcriptpath = resolve-path "$path\sql_log.txt"
$database_path = resolve-path "$path\db_list.xml"
$database_server = "SQL\$path\"

Write-Host "      			"

$my_database = $database_path
[xml]$userfile = Get-Content -Path $my_database 

$my_database_actual = $userfile.databases.database | Where-Object {$_.name -eq $myenv}
$my_database_usage = $my_database_actual.db_name

$my_instance = $userfile.databases.database | Where-Object {$_.name -eq $myenv}
$my_instance_usage = $my_database_actual.instance


$my_password = $userfile.databases.database | Where-Object {$_.name -eq $myenv}
$my_password_usage = $my_database_actual.password

$my_userid = $userfile.databases.database | Where-Object {$_.name -eq $myenv}
$my_userid_usage = $my_database_actual.userid

Write-Host "read file of sql_order.xml"
Write-Host "      			"

$sqlorderpath = $sqlpath
[xml]$userfile = Get-Content -Path $sqlorderpath

$my_var_that_will_change = $userfile.sqlschema.name

$my_db_that_will_change = $my_database_usage

Write-Host "      			"

Write-Host "Variable Settings"
Write-Host "      			"
Write-Host "The environment you requested is:   "$myenv 
Write-Host "Servername being set up:            " $my_instance 
Write-Host "Instance to use for set up:         " $my_instance_usage  
Write-Host "Database to use, (prod/test/dev):   " $my_database_usage 
Write-Host "userid to use in the database:      " $my_userid_usage 
Write-Host "pasword for userid:                 " $my_password_usage 

Write-Host "      			"

Write-Host "Path Settings for Sqlps"
Write-Host "cd SQL\$my_instance_usage\Databases\$my_database_usage"
Write-Host "      			"


Write-Host "Starting"
Import-Module SQLPS
cd SQLSERVER:
#cd SQL\$my_instance_usage\Databases\$my_database_usage


Start-Transcript -Path $transcriptpath

$WarningPreference = "Continue"
$VerbosePreference = "Continue"

Write-Host "      			"
Write-Host "Date time"
Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery;" -serverinstance $my_instance_usage -database $my_database_usage -username $my_userid_usage -password $my_password_usage

Write-Host "      			"
Write-Host "before script"


$sqlstring = Get-Content $filebefore | Out-String
$sqlstring = $sqlstring -Replace "schema_name_STTI", "$my_var_that_will_change" -Replace "db_name_STTI", "$my_db_that_will_change" 




Invoke-Sqlcmd -Query $sqlstring -serverinstance $my_instance_usage -database $my_database_usage -username $my_userid_usage -password $my_password_usage 


Write-Host "      			"
Write-Host "start loop"
foreach( $sqlfile in $userfile.sqlschema.sqlfile) 
{
   Invoke-Sqlcmd -InputFile $sqlfile.name -serverinstance $my_instance_usage -database $my_database_usage -username $my_userid_usage -password $my_password_usage
   Write-Host "Inside loop"
}

Write-Host "      			"
Write-Output "Loop done"
Invoke-Sqlcmd -InputFile $fileafter -serverinstance $my_instance_usage -database $my_database_usage -username $my_userid_usage -password $my_password_usage

Write-Host "      			"
Write-Host "SQLCMD done'"

Stop-Transcript

cd C:
cd $path