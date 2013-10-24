DROP PROCEDURE HRS.client_stti_AnnualDonor_Segments
GO
CREATE PROCEDURE HRS.client_stti_AnnualDonor_Segments
AS

	SELECT
		'FY' + afy_code AS Name,
		afy_code AS Id
	FROM
		ac_ar_fiscal_year (NOLOCK)
	WHERE
		afy_atc_key = '012E30FA-6643-4564-A8A6-C87052D94FB4'
		AND afy_end_date >= DATEADD(YEAR,-2,GETDATE())
		AND afy_start_date <= GETDATE()