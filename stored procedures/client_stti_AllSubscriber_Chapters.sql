DROP PROCEDURE HRS.client_stti_AllSubscriber_Chapters
GO
CREATE PROCEDURE HRS.client_stti_AllSubscriber_Chapters
AS

	SELECT 
		chp_cst_key AS ChapterId,
		chp_code AS ChapterCode,
		chp_name AS ChapterName,
		cst_ind_full_name_dn AS ContactName,
		eml_address AS ContactEmail,
		ISNULL(pht_code+'-','') + cph_phn_number_complete AS ContactPhone
	FROM 
		co_chapter (NOLOCK)
		LEFT JOIN (SELECT
						cxc_cst_key_2,
						cst_ind_full_name_dn,
						eml_address,
						pht_code,
						cph_phn_number_complete
					FROM
						co_customer_x_customer (NOLOCK) 
						JOIN co_customer_x_customer_ext (NOLOCK) ON cxc_key_ext = cxc_key   
						JOIN co_customer (NOLOCK)  ON cst_key = cxc_cst_key_1
						JOIN co_relationship_type (NOLOCK) ON rlt_code = cxc_rlt_code AND rlt_type = 'Ind_Chap'
						LEFT JOIN co_email (NOLOCK) ON eml_key = ISNULL(cxc_primary_eml_key_ext,cst_eml_key) AND eml_delete_flag = 0
						LEFT JOIN (co_customer_x_phone (NOLOCK)
									JOIN co_phone_type (NOLOCK) ON pht_key = cph_pht_key) 
									ON cph_key = ISNULL(cxc_primary_cph_key_ext,cst_cph_key) AND cph_delete_flag = 0
					WHERE
						cxc_rlt_code = 'Contact' 
						AND cxc_delete_flag = 0
						AND ISNULL(cxc_start_date,DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
						AND ISNULL(cxc_end_date,DATEADD(YEAR,1,GETDATE())) >= GETDATE()
					) Contacts ON chp_cst_key = cxc_cst_key_2
		WHERE
			(chp_terminate_date IS NULL
			OR chp_terminate_date <= GETDATE())
			AND chp_delete_flag = 0

	