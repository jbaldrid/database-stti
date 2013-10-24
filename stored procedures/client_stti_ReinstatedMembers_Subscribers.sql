DROP PROCEDURE HRS.client_stti_ReinstatedMembers_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_ReinstatedMembers_Subscribers
	@ChangeDate	DATETIME
AS
	/*
		DECLARE @ChangeDate	DATETIME = '1/15/2013'
	--*/

	SELECT
		eml_address AS Email
	FROM
		mb_membership (NOLOCK)
		JOIN mb_membership_x_ac_invoice (NOLOCK) ON mxi_mbr_key = mbr_key
		JOIN co_customer (NOLOCK) ON cst_key = mbr_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		mbr_delete_flag = 0
		AND mxi_delete_flag = 0
		AND cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND mbr_chp_cst_key IS NULL
		AND mbr_terminate_date IS NULL
		AND mxi_rejoin_flag = 1
		AND mbr_rejoin_date >= @ChangeDate
		AND [STTI].client_stti_GetMemberStatus(cst_key) = 1
		
