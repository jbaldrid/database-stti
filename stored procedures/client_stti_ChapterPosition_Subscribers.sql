/*           ###CHAPTER POSTION Subscribers### */
DROP PROCEDURE [HRS].[client_stti_ChapterPosition_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_ChapterPosition_Subscribers] @Id nvarchar(50)
AS
SELECT
                                eml.eml_address AS Email
                FROM
                                co_email eml (NOLOCK)
                                JOIN co_customer cst (NOLOCK) ON eml.eml_key=cst.cst_eml_key
                                JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
                                JOIN co_chapter_x_customer cpx (NOLOCK) ON cpx.cpx_cst_key=cst.cst_key
                WHERE
                                cst.cst_delete_flag = 0
                                AND cst.cst_eml_address_dn is NOT NULL
                                AND ind.ind_deceased_flag=0
                                AND eml.eml_invalid_flag=0
                                and eml.eml_address <> ''
                                and eml.eml_address is NOT NULL
                                and cpx_delete_flag=0
                                AND cpx.cpx_cpo_code=@Id
                                AND (cpx.cpx_start_date IS NULL OR cpx.cpx_start_date <= GETDATE())
                                AND (cpx.cpx_end_date IS NULL OR cpx.cpx_end_date >= GETDATE())
GO
