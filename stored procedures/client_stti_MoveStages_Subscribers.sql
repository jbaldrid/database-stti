DROP PROCEDURE HRS.client_stti_MoveStages_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_MoveStages_Subscribers
	@Id	NVARCHAR(200)
AS


	/*
		DECLARE @Id	NVARCHAR(200) = 'First2_HoldingPeriod'
	*/

	SELECT
		eml_address AS Email
	FROM
		sf_opportunity (NOLOCK)
		JOIN co_customer (NOLOCK) ON cst_key = sfo_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND sfo_delete_flag = 0
		AND sfo_sos_code = @Id
		
