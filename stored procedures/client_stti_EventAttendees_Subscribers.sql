DROP PROCEDURE [HRS].client_stti_EventAttendees_Subscribers
GO
CREATE PROCEDURE [HRS].client_stti_EventAttendees_Subscribers
	@Id	UNIQUEIDENTIFIER
AS

	/*
		DECLARE @eventKey UNIQUEIDENTIFIER = 'D164DE32-780C-437D-B194-0C05FEF521E8'
	*/
	
	SELECT
		eml_address AS Email
	FROM
		ev_registrant (NOLOCK)
		JOIN co_customer (NOLOCK) ON cst_key = reg_cst_key
		JOIN co_individual (NOLOCK) ON ind_cst_key = cst_key
		JOIN co_email (NOLOCK) ON eml_key = cst_eml_key
	WHERE
		reg_delete_flag = 0
		AND cst_delete_flag = 0
		AND ind_deceased_flag = 0
		AND eml_delete_flag = 0
		AND eml_address <> ''
		AND eml_address IS NOT NULL
		AND eml_invalid_flag = 0
		AND reg_evt_key = @Id
		AND reg_cancel_date IS NULL
		