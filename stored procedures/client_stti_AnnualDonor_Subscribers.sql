DROP PROCEDURE HRS.client_stti_AnnualDonor_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_AnnualDonor_Subscribers
	@Id	NVARCHAR(10)
AS

	/*
		DECLARE @Id	NVARCHAR(10) = '2012'
	*/
	DECLARE @Start	DATETIME = '7/1/' + CONVERT(NVARCHAR(4),(CONVERT(INT,@Id) - 1))
	DECLARE @End	DATETIME = '6/30/' + @Id
	
	SELECT DISTINCT
		eml_address AS Email
	FROM
		STTI.vw_client_stti_Gift (NOLOCK)
		JOIN co_customer (NOLOCK) ON cst_key = CustomerId
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND CASE WHEN GiftCategory = 'Pledge-Payment' THEN PayDate ELSE OriginalGiftDate END BETWEEN @Start AND @End
		AND Location <> 'Chapter Gifts'
		AND GiftCategory IN ('Foundation Gift','Recurring Gift', 'Pledge-Initial')
