CREATE PROCEDURE [HRS].client_stti_Calendar_GetRecordById
	@Id	UNIQUEIDENTIFIER
AS

	
	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailCalendar (NOLOCK)
	WHERE
		IsDeleted = 0
		AND Id = @Id