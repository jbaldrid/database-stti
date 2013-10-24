CREATE PROCEDURE HRS.client_stti_TypeOfPosition_Subscribers
	@Id	UNIQUEIDENTIFIER
AS

	/*
		DECLARE @Id	UNIQUEIDENTIFIER = 'DA0C3236-BEFF-481D-92B9-08906DC1CBB4'
	--*/

	SELECT
		eml_address AS Email
	FROM
		client_STTI_demographics_individual_response (NOLOCK)
		JOIN client_stti_demographics_survey_individual (NOLOCK) ON d10_key = d07_d10_key
		JOIN co_customer (NOLOCK) ON cst_key = d10_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		d07_delete_flag = 0
		AND d10_delete_flag = 0
		AND cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND d07_d06_key = @Id
		AND d10_entry_date >= DATEADD(YEAR,-5,GETDATE())