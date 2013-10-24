/*	###NKI Presence Event Segments###	*/
DROP PROCEDURE [HRS].[client_stti_NKIPresenceEvent_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_NKIPresenceEvent_Segments]
AS
SELECT
		n03_name AS Name,
		n03_key AS Id
	FROM
		client_stti_nki_presence_event (NOLOCK)
	WHERE
		n03_delete_flag = 0
		AND n03_name is NOT NULL
		
GO