CREATE VIEW [HRS].vw_client_stti_EmailCalendar
AS

	SELECT
		i14_key AS Id,
		i14_i13_key AS BlueprintId,
		i14_instance_key AS ObjectInstanceId,
		i14_send_date AS SendDate,
		i14_status AS SendStatus,
		i14_custom_text AS CustomText,
		i14_custom_subject AS CustomSubjectLine,
		i14_start_date AS SendStartDate,
		i14_completion_date AS SendCompletionDate,
		i14_delete_flag AS IsDeleted
	FROM
		client_stti_email_calendar (NOLOCK)
