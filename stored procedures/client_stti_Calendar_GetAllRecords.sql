CREATE PROCEDURE [HRS].client_stti_Calendar_GetAllRecords
AS
	
	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailCalendar (NOLOCK)
