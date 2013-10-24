
CREATE PROCEDURE HRS.client_stti_ChapterAnnualReport_Subscribers
	@Id	NVARCHAR(40)
AS

	/*
		DECLARE @Id	NVARCHAR(40) = 'C:92C9D5BE-F65B-4F77-B602-0AD809B92BAD'
	*/
	
	DECLARE @survey_key UNIQUEIDENTIFIER = RIGHT(@Id,36)
	DECLARE @completion NVARCHAR(1) = LEFT(@Id,1)


	SELECT
		d10_cst_key,
		d10_entry_date
	INTO #Submissions
	FROM
		client_STTI_demographics_survey_individual (NOLOCK)
	WHERE
		d10_d01_key = @survey_key

	SELECT
		chp_cst_key,
		chp_code,
		chp_name,
		d10_entry_date
	INTO #Chapters
	FROM
		co_chapter (NOLOCK)
		LEFT JOIN #Submissions ON chp_cst_key = d10_cst_key
	WHERE
		chp_delete_flag = 0
		AND (chp_terminate_date IS NULL OR chp_terminate_date > GETDATE())
		AND (
				(@completion = 'C' AND d10_entry_date <= GETDATE())
				OR
				(@completion = 'N' AND d10_cst_key IS NULL)
				OR 
				(@completion = 'P' AND d10_entry_date > GETDATE())
			)
				

	SELECT
		eml_address AS Email
	FROM
		co_chapter_x_customer (NOLOCK)
		JOIN #Chapters ON cpx_chp_cst_key = chp_cst_key
		JOIN co_customer (NOLOCK) ON  cpx_cst_key = cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND ISNULL(cpx_start_date,DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
		AND ISNULL(cpx_end_date,DATEADD(YEAR,1,GETDATE())) >= GETDATE()
		AND cpx_cpo_code IN ('PRES','TREAS')

	DROP TABLE #Submissions
	DROP TABLE #Chapters