CREATE PROCEDURE [HRS].client_stti_Blueprint_GetAllRecords
AS

	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailBlueprint (NOLOCK)
