DROP PROCEDURE [HRS].client_stti_Committees_Segments
GO
CREATE PROCEDURE [HRS].client_stti_Committees_Segments
AS

	SELECT
		cmt_name AS Name,
		cmt_key AS Id
	FROM
		mb_committee (NOLOCK)
	WHERE
		cmt_delete_flag = 0
		AND ISNULL(cmt_begin_date, DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
		AND ISNULL(cmt_end_date, DATEADD(YEAR,1,GETDATE())) >= GETDATE()