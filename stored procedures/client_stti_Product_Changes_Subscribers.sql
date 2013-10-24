DROP PROCEDURE HRS.client_stti_Product_Changes_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_Product_Changes_Subscribers
	@Id	UNIQUEIDENTIFIER,
	@ChangeDate	DATETIME
AS
	/*
		DECLARE @Id UNIQUEIDENTIFIER = '224A8F5B-D784-4AE8-87E8-B7463007E1D4'
		DECLARE @ChangeDate	DATETIME = '4/1/2013'
	--*/

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
		AND (
				ISNULL(net_ivd_change_date, net_ivd_add_date) >= @ChangeDate
				OR ISNULL(cst_change_date, cst_add_date) >= @ChangeDate
				OR ISNULL(eml_change_date, eml_add_date) >= @ChangeDate
			)		