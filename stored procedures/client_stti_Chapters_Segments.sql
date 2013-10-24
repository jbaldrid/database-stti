CREATE PROCEDURE HRS.client_stti_Chapters_Segments
AS

	SELECT
		RIGHT(chp_code,3) + '-' + chp_name AS Name,
		chp_cst_key AS Id
	FROM
		co_chapter (NOLOCK)
	WHERE
		chp_delete_flag = 0
		AND ISNULL(chp_terminate_date,DATEADD(YEAR,10,GETDATE())) >= GETDATE()
	