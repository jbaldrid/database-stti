CREATE VIEW [HRS].vw_client_stti_EmailBlueprint
AS

	SELECT
		i13_key AS Id,
		i13_code AS Code,
		i13_description AS Description,
		i13_bh_template_id AS BHTemplateId,
		i13_send_logic AS SendLogic,
		i13_recipient_type AS RecipientType,
		i13_recipient_query AS RecipientQuery,
		i13_i12_key AS TriggerTypeId,
		i13_customization AS CustomizationAllowed,
		i13_amsconnect_object_type AS AMSConnectObjectType,
		i13_delete_flag AS IsDeleted
	FROM
		client_stti_email_blueprint (NOLOCK)