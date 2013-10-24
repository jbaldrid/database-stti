CREATE PROCEDURE [HRS].client_stti_Calendar_GetRecordsByBlueprintId
	@BlueprintId	UNIQUEIDENTIFIER
AS

	
	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailCalendar (NOLOCK)
	WHERE
		IsDeleted = 0
		AND BlueprintId = @BlueprintId