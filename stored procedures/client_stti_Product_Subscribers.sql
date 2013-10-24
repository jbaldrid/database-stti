DROP PROCEDURE HRS.client_stti_Product_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_Product_Subscribers
	@Id	UNIQUEIDENTIFIER
AS
	/*
		DECLARE @Id UNIQUEIDENTIFIER = '4D117BF5-FCA2-4F14-BA3F-02EE37526235'
	*/

	SELECT DISTINCT
		eml_address AS Email
	FROM
		vw_ac_invoice_detail (NOLOCK)
		JOIN co_customer (NOLOCK) ON cst_key = net_ivd_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND net_ivd_prc_prd_key = @Id
		AND net_balance_quantity > 0
		AND net_ivd_void_flag = 0
		AND net_closed = 1