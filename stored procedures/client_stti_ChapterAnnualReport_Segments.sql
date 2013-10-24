CREATE PROCEDURE HRS.client_stti_ChapterAnnualReport_Segments
AS

	SELECT
		d01_name + ': Completed' AS Name,
		'C:' + CONVERT(NVARCHAR(40),d01_key) AS Id
	FROM
		client_stti_Demographics_Survey (NOLOCK)
	WHERE
		d01_d11_key = '8B00F2B9-E9B0-4768-A460-72AC12581327'

	UNION

	SELECT
		d01_name + ': Not Started' AS Name,
		'N:' + CONVERT(NVARCHAR(40),d01_key) AS Id
	FROM
		client_stti_Demographics_Survey (NOLOCK)
	WHERE
		d01_d11_key = '8B00F2B9-E9B0-4768-A460-72AC12581327'

	UNION

	SELECT
		d01_name + ': In Progress' AS Name,
		'P:' + CONVERT(NVARCHAR(40),d01_key) AS Id
	FROM
		client_stti_Demographics_Survey (NOLOCK)
	WHERE
		d01_d11_key = '8B00F2B9-E9B0-4768-A460-72AC12581327'