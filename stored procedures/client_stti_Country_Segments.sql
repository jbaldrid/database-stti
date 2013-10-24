/*           ###Country Segments###          */
DROP PROCEDURE [HRS].[client_stti_Country_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_Country_Segments]
AS
SELECT
                                cty_long_name AS Name,
                                cty_code AS Id
                FROM
                                co_country (NOLOCK)
                WHERE
                                cty_delete_flag = 0
                                and len(cty_code) > 0
                                and cty_long_name is NOT NULL
GO
