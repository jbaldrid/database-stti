CREATE PROCEDURE HRS.client_stti_MemberStatus_Segments
AS

	SELECT
		'Active Member' AS Name,
		1 AS Id

	UNION

	SELECT
		'Inctive Member' AS Name,
		0 AS Id
