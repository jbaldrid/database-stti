database-stti
=============

Application based on SQL, XML and Powershell to track changes in a database and email a change log to desired developers




This program is designed to take in a powershell executable page to work with a SQL database. The idea is to compare changes in the database and send those changes out to desired developers.

The powershell executable file is in the DBDeploy folder and the file is deploy.ps1.
  
  The powershell program is based on the two deployment schemas before and after in the DBDeploy folder
  
You use Windows Powershell to run the command (../deploy.ps1) with the .. representing where the powershell file is stored at on your local machine

  i.e. c:\Users\baylor\Documents\database deployment script\deploy.ps1
  
It then uses the other sql schemas and also the sqls in the stored procedures to say what files to compare in the database

Then it will create a log at sql_log.txt and that records the changes and dropped procedures in the database.

Then you can email this out manually to your desired parties or set up with what we used was through the Bamboo Application with Atlassian.

Lead develepor: Baylor Aldridge

Organiztion: Sigma Theta Tau International, Honor Society of Nursing

Thank you
Baylor A.
