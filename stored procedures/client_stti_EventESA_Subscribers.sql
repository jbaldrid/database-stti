DROP PROCEDURE [HRS].client_stti_EventESA_Subscribers
GO
CREATE PROCEDURE [HRS].client_stti_EventESA_Subscribers
	@Id UNIQUEIDENTIFIER
AS

	/*
		DECLARE @Id UNIQUEIDENTIFIER = '2F857E2E-FFDB-49EA-BC73-F98E9CF11502'
	*/
	
	--Pull sponsorship contacts if available
	SELECT DISTINCT
		eml_address As Email
	FROM
		ev_event_sponsor (NOLOCK)
		LEFT JOIN ex_show (NOLOCK) ON exb_key = spo_exb_key
		JOIN co_customer o (NOLOCK) ON o.cst_key = spo_cst_key
		JOIN ev_sponsor_contact (NOLOCK) ON spc_spo_key = spo_key
		JOIN co_customer i (NOLOCK) ON i.cst_key = spc_ind_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = i.cst_key
		JOIN co_email (NOLOCK) ON eml_key = i.cst_eml_key
	WHERE
		spo_delete_flag = 0
		AND o.cst_delete_flag = 0
		AND spc_delete_flag = 0
		AND i.cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND (spo_evt_key = @Id OR exb_evt_key = @Id)
		
	UNION

	--Pull ESA Contact relationship, if no sponsorship contact listed
	SELECT DISTINCT
		eml_address As Email
	FROM
		ev_event_sponsor (NOLOCK)
		LEFT JOIN ex_show (NOLOCK) ON exb_key = spo_exb_key
		JOIN co_customer o (NOLOCK) ON o.cst_key = spo_cst_key
		LEFT JOIN ev_sponsor_contact (NOLOCK) ON spc_spo_key = spo_key
		JOIN co_individual_x_organization (NOLOCK) ON ixo_org_cst_key = o.cst_key
		JOIN co_customer i (NOLOCK) ON i.cst_key = ixo_ind_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = i.cst_key
		JOIN co_email (NOLOCK) ON eml_key = i.cst_eml_key
	WHERE
		spo_delete_flag = 0
		AND o.cst_delete_flag = 0
		AND ixo_delete_flag = 0
		AND i.cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND spc_key IS NULL
		AND ISNULL(ixo_start_date, DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
		AND ISNULL(ixo_end_date, DATEADD(YEAR,1,GETDATE())) >= GETDATE()
		AND ixo_rlt_code = 'ESA Contact'
		AND (spo_evt_key = @Id OR exb_evt_key = @Id)

