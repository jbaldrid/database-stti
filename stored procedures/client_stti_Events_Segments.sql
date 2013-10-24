DROP PROCEDURE [HRS].client_stti_Events_Segments 
GO

CREATE PROCEDURE [HRS].client_stti_Events_Segments
AS

	SELECT
		evt_title AS Name,
		evt_key AS Id		
	FROM
		ev_event (NOLOCK)
	WHERE
		evt_delete_flag = 0