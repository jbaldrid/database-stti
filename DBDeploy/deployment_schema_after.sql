/*************************************************/

-- Run files    

/*************************************************/


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


INSERT INTO TEMPTABLE SELECT @schema + '.' + name, HashBytes('SHA1', OBJECT_DEFINITION (OBJECT_ID(name ))) , 'after'
		FROM sys.objects
		WHERE schema_id = @schema_id
		and type in ('FN', 'FS', 'FT', 'IF', 'TF','P', 'V');

DECLARE cursor_print CURSOR 

		FOR select b.name + ' deleted' from (select * from TEMPTABLE where STAGE='before') b LEFT JOIN (select * from TEMPTABLE where STAGE= 'after') a on b.name = a.name where a.def IS NULL
	union
select a.name + ' created' from (select * from TEMPTABLE where STAGE='before') b RIGHT JOIN (select * from TEMPTABLE where STAGE= 'after') a on b.name = a.name where b.def IS NULL
	union
select a.name + 'changed' from (select * from TEMPTABLE where STAGE='before') b JOIN (select * from TEMPTABLE where STAGE= 'after') a on b.name = a.name where b.def != a.def; 


	OPEN cursor_print;

	FETCH NEXT FROM cursor_print INTO @printmessage

	WHILE @@FETCH_STATUS = 0
	BEGIN

	PRINT @PrintMessage


	FETCH NEXT FROM cursor_print INTO @printmessage

		

	END;

	CLOSE cursor_print;
	DEALLOCATE cursor_print;