/*           ###State Segments###                */
DROP PROCEDURE [HRS].[client_stti_State_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_State_Segments]
AS
SELECT
                                sta_name AS Name,
                                sta_code AS Id
                FROM
                                co_state_territory (NOLOCK)
                WHERE
                                sta_delete_flag=0
                                and len(sta_code) > 0
                                and sta_name is NOT NULL
GO
