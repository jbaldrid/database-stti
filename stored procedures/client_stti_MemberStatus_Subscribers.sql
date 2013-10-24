DROP PROCEDURE HRS.client_stti_MemberStatus_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_MemberStatus_Subscribers
	@Id	INT
AS

	/*
		DECLARE @Id INT = 1
	*/

	SELECT DISTINCT
		eml_address AS Email
	FROM
		co_customer (NOLOCK)
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
		JOIN STTI.vw_client_stti_LatestMembershipRecordDetail ON v01_cst_key = cst_key AND v01_chp_cst_key IS NULL
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND v01_Active_Flag = @Id
