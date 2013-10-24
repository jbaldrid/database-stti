DROP PROCEDURE [HRS].client_stti_TriggerType_GetAllRecords
GO
CREATE PROCEDURE [HRS].client_stti_TriggerType_GetAllRecords
AS

	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailTriggerType (NOLOCK)
