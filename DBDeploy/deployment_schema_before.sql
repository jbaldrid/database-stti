/**************************************************************************
-- Database Deployment Script Project

-- Project helps to be able to deploy the database assets that are associated with a specific AMSConnect Endpoint, or Report Repository via Atlassian Bambbo.

-- Creates a Schema that shows the diferences of the schema being compared

-- Run the SQL files in the specified git repository

-- Document the objects in the schema

-- Add to the original report all of the errors

-- To email DJ, Frank, and Sheri about any changes once this schema has run through it's tasks and send the created schema document of the changes

**************************************************************************/



/**************************************************************************

-- Create a new schema to compare the base schema

**************************************************************************/

USE db_name_STTI
GO


DECLARE @schema varchar(MAX);
DECLARE @schema_id int;
DECLARE	@object_name varchar(MAX);
DECLARE @spdefinition nvarchar(4000);
DECLARE @hashedVal varbinary(4000);
DECLARE @ddl_statement varchar(MAX);
DECLARE @drop_procedure varchar(MAX);
DECLARE @counter INT;
DECLARE @loop_schema_id int;
DECLARE @printmessage varchar(MAX);

SET @schema = 'schema_name_STTI';

SET @schema_id = (SELECT schema_id FROM sys.schemas WHERE name = @schema);
SET @loop_schema_id = @schema_id;
SET @counter = 0

print @schema_id


/**************************************************************************

-- Delete stored Procedures

**************************************************************************/
DROP TABLE TEMPTABLE;
CREATE TABLE TEMPTABLE (name varchar(max), def varchar(max),stage varchar(10));

WHILE @counter <= 10 and ISNull(@loop_schema_id ,0) != 0
	BEGIN
PRINT '************* STARTING TO REMOVE Unessary Items **************************';


	DECLARE proc_cursor CURSOR 
		FOR SELECT name, type 
		FROM sys.objects
		WHERE schema_id = @schema_id
		and type in ('FN', 'FS', 'FT', 'IF', 'TF','P', 'V')

	OPEN proc_cursor;

	FETCH NEXT FROM proc_cursor INTO @object_name, @drop_procedure;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @object_name = @schema + '.' + @object_name;
		SET @spdefinition = (SELECT OBJECT_DEFINITION (OBJECT_ID(@object_name )))    
		SET @hashedVal = (select HashBytes('SHA1', @spdefinition))

		SET @ddl_statement = 'DROP ' + 
			CASE @drop_procedure
				WHEN 'P' THEN 'PROCEDURE'
				WHEN 'FS' THEN 'FUNCTION'
				WHEN 'FN' THEN 'FUNCTION'
				WHEN 'FT' THEN 'FUNCTION'
				WHEN 'IF' THEN 'FUNCTION'
				WHEN 'TF' THEN 'FUNCTION'
				WHEN 'V' THEN 'VIEW'
				ELSE 'NO FUNCITONS FOUND'
			END + ' ' + @object_name
		


		INSERT INTO TEMPTABLE SELECT @object_name, @hashedVal, 'before'
		
		PRINT @ddl_statement;
		EXEC(@ddl_statement)
		
		FETCH NEXT FROM proc_cursor INTO @object_name, @drop_procedure;

	END;

	CLOSE proc_cursor;
	DEALLOCATE proc_cursor;

	EXEC('DROP SCHEMA ' + @schema )
	SET @loop_schema_id = (SELECT schema_id FROM sys.schemas WHERE name = @schema);
	SET @counter += 1;


END;

EXEC('CREATE SCHEMA ' + @schema )