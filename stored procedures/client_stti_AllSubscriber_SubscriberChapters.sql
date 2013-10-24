DROP PROCEDURE HRS.client_stti_AllSubscriber_SubscriberChapters
GO
CREATE PROCEDURE HRS.client_stti_AllSubscriber_SubscriberChapters
AS


	SELECT
		*
	INTO #ChapterMembership
	FROM
		STTI.vw_client_stti_LatestMembershipRecordDetail
	WHERE
		v01_chp_cst_key IS NOT NULL


	SELECT --TOP 10
		cst_key AS CustomerId,
		v01_chp_cst_key AS ChapterId,
		ISNULL(cpo_description, cpx_cpo_code) AS PositionName
	FROM
		co_customer (NOLOCK)
		JOIN co_individual (NOLOCK) ON  ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON cst_eml_key = eml_key
		JOIN #ChapterMembership ON v01_cst_key = cst_key
		LEFT JOIN (co_chapter_x_customer (NOLOCK)
					JOIN mb_committee_position (NOLOCK) ON cpo_code = cpx_cpo_code) 
					ON cpx_chp_cst_key = v01_chp_cst_key AND cpx_cst_key = cst_key AND ISNULL(cpx_start_date, DATEADD(YEAR,-1,GETDATE())) <= GETDATE()
						AND ISNULL(cpx_end_date, DATEADD(YEAR,1,GETDATE())) >= GETDATE()
	WHERE
		cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_invalid_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL

	DROP TABLE #ChapterMembership