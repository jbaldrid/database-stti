CREATE PROCEDURE [HRS].client_stti_Blueprint_GetRecordById
	@Id UNIQUEIDENTIFIER
AS

	SELECT
		*
	FROM
		[HRS].vw_client_stti_EmailBlueprint (NOLOCK)
	WHERE
		IsDeleted = 0
		AND Id = @Id