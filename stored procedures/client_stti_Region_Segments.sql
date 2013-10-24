/*           ###Region Segments###             */
DROP PROCEDURE [HRS].[client_stti_Region_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_Region_Segments]
AS
SELECT
                                Name = CASE
                                                WHEN x01_x01_key is NULL
                                                THEN x01_description
                                                ELSE ('North America '+x01_description)
                                                END,
                                x01_key AS Id
                                                                
                FROM
                                client_stti_region (NOLOCK)
                WHERE
                                x01_delete_flag=0
GO
