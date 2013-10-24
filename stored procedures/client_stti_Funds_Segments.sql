CREATE PROCEDURE HRS.client_stti_Funds_Segments
AS

	SELECT DISTINCT
		ISNULL(p.prd_name,c.prd_name) AS Name,
		ISNULL(p.prd_key,c.prd_key) AS Id
	FROM
		oe_product c (NOLOCK)
		JOIN np_fund_product (NOLOCK) ON fpc_prd_key = prd_key
		JOIN oe_product_ext (NOLOCK) ON prd_key_ext = c.prd_key
		LEFT JOIN oe_product p (NOLOCK) ON p.prd_key = prd_parent_prd_key_ext
	WHERE
		fpc_delete_flag = 0
		AND c.prd_delete_flag = 0