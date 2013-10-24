DROP PROCEDURE [HRS].client_stti_AllSubscriber
GO
CREATE PROCEDURE [HRS].client_stti_AllSubscriber
AS

	SELECT 
		inv_cst_key,
		inv_key,
		ivd_key,
		inv_code,
		ivd_qty - ISNULL(ret_qty,0) AS TotalQty,
		CASE WHEN prd_dues_category_ext IN ('Retired','Student','TempOut') THEN ivd_price * 2 ELSE ivd_price END FullPrice,
		prd_dues_category_ext,
		OriginalPayDate,
		LastPayDate,
		PaymentAmount
	INTO #Invoices
	FROM
		ac_invoice (NOLOCK)
		JOIN ac_invoice_detail (NOLOCK) ON inv_key = ivd_inv_key
		JOIN oe_product_type (NOLOCK) ON ivd_prc_prd_ptp_key = ptp_key
		JOIN oe_product (NOLOCK) ON ivd_pak_prd_key = prd_key
		JOIN oe_product_ext (NOLOCK) ON prd_key = prd_key_ext
		LEFT JOIN ac_return (NOLOCK) ON ivd_key = ret_ivd_key
		LEFT JOIN (SELECT
						pyd_ivd_key,
						MIN(pay_trx_date) AS OriginalPayDate,
						MAX(pay_trx_date) AS LastPayDate,
						SUM(ISNULL(pyd_amount,0))AS PaymentAmount
					FROM
						ac_payment (NOLOCK)
						JOIN ac_payment_detail (NOLOCK) ON pay_key = pyd_pay_key
					WHERE
						pyd_void_flag = 0
						AND pyd_ajd_key IS NULL
						AND pyd_delete_flag = 0
						AND pay_delete_flag = 0
						AND pyd_type NOT IN ('return', 'writeoff')
					GROUP BY pyd_ivd_key
				) Payments ON ivd_key = pyd_ivd_key
	WHERE
		inv_delete_flag = 0
		AND ivd_delete_flag = 0
		AND inv_close_flag = 0
		AND ivd_void_flag = 0
		AND ivd_ajd_key IS NULL
		AND ptp_code = 'Membership Dues'
		AND prd_dues_category_ext <> 'New'
		AND ivd_qty - ISNULL(ret_qty,0) > 0


	SELECT
		eml_address AS EmailAddress,
		ind_first_name AS FirstName,
		ind_last_name AS LastName,
		STTI.client_stti_GetFormattedMemberNumber(cst_key) AS ConstituentID,
		adr_line1 AS AddressLine1,
		adr_line2 AS AddressLine2,
		adr_city AS City,
		adr_state AS StateProvince,
		adr_post_code AS PostCode,
		adr_country AS Country,
		ind_badge_name AS NickName,
		CASE WHEN (SELECT MAX(mbr_renew_date) AS StartDate FROM mb_membership (NOLOCK) WHERE mbr_cst_key = cst_key AND mbr_delete_flag = 0 AND mbr_renew_date IS NOT NULL AND mbr_chp_cst_key IS NULL) IS NULL 
					THEN NULL ELSE ind_induction_date_ext END AS InductionDate,
		[STTI].client_stti_GetMaxExpirationDate(cst_key) AS MemberExpirationDate,
		s04_add_date AS DateAddedToNKI,
		cst_ixo_title_dn AS Title,
		FirstPay AS OriginalPaymentDate,
		LastPay AS LastPaymentDate,
		InvoiceAmount AS TotalDues,
		(InvoiceAmount - ISNULL(PayAmount,0)) AS CurrentAmountDue,
		cst_key AS CustomerId--,
		--CASE WHEN (SELECT MAX(mbr_renew_date) AS StartDate FROM mb_membership (NOLOCK) WHERE mbr_cst_key = cst_key AND mbr_delete_flag = 0 AND mbr_renew_date IS NOT NULL AND mbr_chp_cst_key IS NULL) IS NULL 
		--			THEN NULL ELSE chp_name END AS InductingChapter
	FROM
		co_individual (NOLOCK)
		JOIN co_individual_ext (NOLOCK) ON ind_cst_key_ext = ind_cst_key
		JOIN co_customer (NOLOCK) ON cst_key = ind_cst_key
		JOIN co_email (NOLOCK) ON eml_cst_key = cst_key
		LEFT JOIN co_chapter (NOLOCK) ON chp_cst_key = ind_inducting_chapter_ext
		LEFT JOIN (co_customer_x_address (NOLOCK) 
					JOIN co_address (NOLOCK) ON adr_key = cxa_adr_key) ON cxa_key = cst_cxa_key
		LEFT JOIN client_stti_customer_x_permission (NOLOCK) ON s04_cst_key = cst_key AND s04_s02_key = '5a1d78d3-63a9-4928-aaab-f3a24cc1ea33'
		LEFT JOIN (SELECT 
						inv_cst_key, 
						MIN(OriginalPayDate) AS FirstPay, 
						MAX(LastPayDate) AS LastPay, 
						SUM(FullPrice) AS InvoiceAmount, 
						SUM(PaymentAmount) AS PayAmount 
					FROM #Invoices GROUP BY inv_cst_key) Inv ON cst_key = inv_cst_key
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_invalid_flag = 0


		DROP TABLE #Invoices