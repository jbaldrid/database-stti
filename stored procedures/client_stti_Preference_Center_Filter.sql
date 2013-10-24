--USE netFORUMSTTI

CREATE FUNCTION [HRS].[client_stti_Preference_Center_Filter](@Id	UNIQUEIDENTIFIER)
RETURNS NVARCHAR(500)
AS
BEGIN
	/*
		DECLARE @Id	UNIQUEIDENTIFIER	= 'fbbb52b8-b64b-4ba0-9d20-feddcf8467d7'
	*/
	DECLARE @Filter	NVARCHAR(500) = 'All'

	IF STTI.client_stti_GetMemberStatus(@Id) = 1
		SET @Filter = @Filter + ', Active Member'
	
	DECLARE @ChapterOfficers AS TABLE
	(
		cpx_cst_key		UNIQUEIDENTIFIER,
		cpx_cpo_code	NVARCHAR(100)
	)

	INSERT INTO @ChapterOfficers
	SELECT
		cpx_cst_key,
		cpx_cpo_code
	FROM
		co_chapter_x_customer (NOLOCK)
	WHERE
		cpx_delete_flag = 0
		AND ISNULL(cpx_start_date, DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
		AND ISNULL(cpx_end_date, DATEADD(YEAR,1,GETDATE())) >= GETDATE()
		AND cpx_cst_key = @Id

	IF (SELECT COUNT(cpx_cst_key) FROM @ChapterOfficers) > 0
		SET @Filter = @Filter + ', Chapter Officer'

	IF (SELECT COUNT(cpx_cst_key) FROM @ChapterOfficers WHERE cpx_cpo_code IN ('CDEL1', 'CDEL2', 'EDEL1','EDEL2')) > 0
		SET @Filter = @Filter + ', Delegate'

	If (SELECT COUNT(cst_key) FROM co_customer (NOLOCK) JOIN client_stti_customer_x_permission (NOLOCK) ON cst_key = s04_cst_key 
			WHERE s04_delete_flag = 0 AND s04_s01_key = 'C16A2636-A4D5-46F7-B999-B62A31FA6F80') > 0
		SET @Filter = @Filter + ', NKI' 

	If (SELECT COUNT(itr_cst_key) FROM co_interest (NOLOCK) JOIN co_interest_code_ext (NOLOCK) ON itr_itc_key = itc_key_ext 
			WHERE itr_delete_flag = 0 AND itc_heritage_society_newsletter_flag_ext = 1 AND itr_cst_key = @Id) > 0
		SET @Filter = @Filter + ', HS'


	RETURN @Filter
END
	

