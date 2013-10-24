CREATE PROCEDURE HRS.client_stti_MoveStages_Segments
AS

	SELECT
		sot_code + ': ' + sos_code AS Name,
		sos_code AS Id
	FROM
		sf_opportunity_stage (NOLOCK)
		JOIN sf_opportunity_type (NOLOCK) ON sot_key = sos_sot_key