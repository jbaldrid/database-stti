CREATE VIEW [HRS].vw_client_stti_EmailTriggerType
AS

	SELECT
		i12_key AS Id,
		i12_code AS Code,
		i12_description AS Description,
		i12_delete_flag AS IsDeleted
	FROM
		client_stti_email_trigger_type (NOLOCK)
