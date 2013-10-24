CREATE PROCEDURE [HRS].client_stti_Calendar_GetRecordsByInstanceId
	@InstanceId	UNIQUEIDENTIFIER
AS

	
	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailCalendar (NOLOCK)
	WHERE
		IsDeleted = 0
		AND ObjectInstanceId = @InstanceId