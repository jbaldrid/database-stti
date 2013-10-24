CREATE PROCEDURE HRS.client_stti_Workplace_Segments
AS

	SELECT
		a.d14_label AS Name,
		d06_key AS Id
	FROM
		client_STTI_demographics_question (NOLOCK) 
		JOIN client_STTI_demographics_question_x_answer (NOLOCK) ON d12_d03_key = d03_key
		JOIN client_STTI_demographics_answer (NOLOCK) ON d06_key = d12_d06_key
		JOIN client_STTI_demographics_item_label a (NOLOCK) ON a.d14_d06_key = d06_key AND a.d14_is_default_flag = 1 AND a.d14_delete_flag = 0
	WHERE
		d03_key = 'D19A2630-A97C-499D-B3CF-4F8E70403F4F' --Workplace	
		AND d03_delete_flag = 0
		AND d06_delete_flag = 0
		AND d12_delete_flag = 0
	
