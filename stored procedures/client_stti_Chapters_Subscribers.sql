DROP PROCEDURE HRS.client_stti_Chapters_Subscribers
GO
CREATE PROCEDURE HRS.client_stti_Chapters_Subscribers
	@Id	UNIQUEIDENTIFIER
AS
	/*
		DECLARE @Id			UNIQUEIDENTIFIER = '4B1A93FB-61FD-4519-AD14-0310C8423C9F'
	*/
	
	DECLARE @Default	UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	
	SELECT
		eml_address AS Email
	FROM
		[STTI].client_stti_LatestMemberships_ByCustomerAndChapter(@Default,@Id,@Default,@Default)
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