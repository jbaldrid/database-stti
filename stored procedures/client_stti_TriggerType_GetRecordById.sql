CREATE PROCEDURE [HRS].client_stti_TriggerType_GetRecordById
	@TriggerTypeId UNIQUEIDENTIFIER
AS

	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailTriggerType (NOLOCK)
	WHERE
		IsDeleted = 0
		AND TriggerTypeId = @TriggerTypeId