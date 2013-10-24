/*           ###Mailing List Segments###    */
DROP PROCEDURE [HRS].[client_stti_MailList_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_MailList_Segments]
AS
SELECT
                                mls_name AS Name,
                                mls_key AS Id
                FROM
                                mk_mailing_list (NOLOCK)
                WHERE
                                mls_delete_flag = 0
                                AND mls_name is NOT NULL
                                
GO
