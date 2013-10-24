CREATE PROCEDURE HRS.client_stti_Funds_Subscribers
	@Id	UNIQUEIDENTIFIER
AS
	/*
		DECLARE @Id	UNIQUEIDENTIFIER = '3D4715F0-9706-4895-BB0A-13FE94E12B1D'
	*/
	
	SELECT DISTINCT
		eml_address AS Email
	FROM
		np_gift (NOLOCK)
		JOIN vw_ac_invoice_detail (NOLOCK) ON net_ivd_key = gft_ivd_key
		JOIN (oe_product c (NOLOCK) 
				JOIN oe_product_ext (NOLOCK) ON prd_key_ext = c.prd_key
				LEFT JOIN oe_product p (NOLOCK) ON p.prd_key = prd_parent_prd_key_ext) ON c.prd_key = net_ivd_prc_prd_key
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
		AND ISNULL(p.prd_key, c.prd_key) = @Id
		AND net_balance_quantity > 0
		AND net_ivd_void_flag = 0
		AND net_closed = 1