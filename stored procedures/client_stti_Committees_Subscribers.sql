DROP PROCEDURE [HRS].client_stti_Committees_Subscribers
GO
CREATE PROCEDURE [HRS].client_stti_Committees_Subscribers
	@Id UNIQUEIDENTIFIER
AS

	/*
		DECLARE @Id UNIQUEIDENTIFIER = '310EB681-5F8C-4FE0-9FC3-00500F37E1FF'
	*/

	SELECT
		eml_address AS Email
	FROM
		mb_committee_x_customer (NOLOCK)
		JOIN co_customer (NOLOCK) ON cst_key = cmc_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		cmc_delete_flag = 0
		AND cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND cmc_cmt_key = @Id
		AND ISNULL(cmc_start_date, DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
		AND ISNULL(cmc_end_date, DATEADD(YEAR,1,GETDATE())) >= GETDATE()
	