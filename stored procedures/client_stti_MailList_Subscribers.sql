/*           ###Mailing List Subscribers### */
DROP PROCEDURE [HRS].[client_stti_MailList_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_MailList_Subscribers] @Id nvarchar(50)
AS
	SELECT
		eml.eml_address AS Email
	FROM
		mk_mailing_list_detail mld (NOLOCK)
		JOIN co_customer cst (NOLOCK) ON mld.mld_cst_key = cst.cst_key
		JOIN co_individual ind (NOLOCK) ON cst.cst_key = ind.ind_cst_key
		JOIN co_email eml (NOLOCK) ON cst.cst_key = eml.eml_cst_key
	WHERE
		cst.cst_delete_flag = 0
		AND ind.ind_deceased_flag=0
		AND eml.eml_invalid_flag=0
		AND eml.eml_address <> ''
		AND eml.eml_address IS NOT NULL
		AND (
				mld.mld_eml_key = eml.eml_key 
				OR 
				(mld.mld_eml_key IS NULL AND cst.cst_eml_key = eml.eml_key)
			)
		AND mld_delete_flag=0
		AND (mld_end_date IS NULL OR mld_end_date > GetDate())
		AND mld.mld_mls_key = @Id
GO
