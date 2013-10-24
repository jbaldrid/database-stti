DROP PROCEDURE HRS.client_stti_Product_Changes_Segments
GO
CREATE PROCEDURE HRS.client_stti_Product_Changes_Segments
	@ChangeDate	DATETIME
AS
	
	/*
		DECLARE @ChangeDate	DATETIME = '4/1/2013'
	--*/
	
	SELECT DISTINCT
		prd_name + CASE WHEN prd_format IS NULL THEN '' ELSE ' - ' + prd_format END AS Name,
		prd_key AS Id
	FROM
		oe_product (NOLOCK)
		JOIN oe_product_type (NOLOCK) ON ptp_key = prd_ptp_key
		JOIN ac_invoice_detail (NOLOCK) ON ivd_prc_prd_key = prd_key
	WHERE
		prd_delete_flag = 0
		AND ptp_code IN ('Merchandise', 'Publication')
		AND (
				ISNULL(prd_change_date, prd_add_date) >= @ChangeDate
				OR ISNULL(ivd_change_date, ivd_add_date) >= @ChangeDate
			)
		