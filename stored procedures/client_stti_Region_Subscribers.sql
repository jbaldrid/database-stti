/*           ###Region Subscribers###          */
DROP PROCEDURE [HRS].[client_stti_Region_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_Region_Subscribers] @Id nvarchar(40)
AS
DECLARE @Global int, @sql NVARCHAR(2000)
SELECT @Global=             CASE
                                                WHEN (select x01_x01_key from client_stti_region (NOLOCK) where x01_key=@Id) is not null
                                                THEN 0
                                                ELSE 1
                                                END


SELECT @sql = CASE
                WHEN @Global=1
                THEN
                                'SELECT eml.eml_address as Email
                                FROM
                                                co_email eml (NOLOCK)
                                                JOIN co_customer cst (NOLOCK) on eml.eml_key=cst.cst_eml_key
                                                JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
                                                JOIN mb_membership mbr (NOLOCK) on cst.cst_key=mbr.mbr_cst_key
                                                JOIN co_chapter_ext chpX (NOLOCK) ON mbr.mbr_chp_cst_key=chpX.chp_cst_key_ext
                                                JOIN co_chapter chp (NOLOCK) ON chp.chp_cst_key=chpX.chp_cst_key_ext
                                                where chpx.chp_x01_key_global_ext='''+@Id+'''
                                                and cst.cst_delete_flag=0
                                                and cst.cst_eml_address_dn is NOT NULL
                                                and ind.ind_deceased_flag=0
                                                and eml.eml_invalid_flag=0
                                                and eml.eml_address <> ''''
                                                and eml.eml_address is NOT NULL
                                                and ind.ind_delete_flag=0
                                                and mbr.mbr_delete_flag=0
                                                and chp.chp_delete_flag=0
                                                and eml.eml_delete_flag=0'
                ELSE
                                'SELECT eml.eml_address as Email
                                FROM
                                                co_email eml (NOLOCK)
                                                JOIN co_customer cst (NOLOCK) on eml.eml_key=cst.cst_eml_key
                                                JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
                                                JOIN mb_membership mbr (NOLOCK) on cst.cst_key=mbr.mbr_cst_key
                                                JOIN co_chapter_ext chpX (NOLOCK) ON mbr.mbr_chp_cst_key=chpX.chp_cst_key_ext
                                                JOIN co_chapter chp (NOLOCK) ON chp.chp_cst_key=chpX.chp_cst_key_ext
                                                where chpx.chp_x01_key_ext='''+@Id+'''
                                                and cst.cst_delete_flag=0
                                                and cst.cst_eml_address_dn is NOT NULL
                                                and ind.ind_deceased_flag=0
                                                and eml.eml_invalid_flag=0
                                                and eml.eml_address <> ''''
                                                and eml.eml_address is NOT NULL
                                                and ind.ind_delete_flag=0
                                                and mbr.mbr_delete_flag=0
                                                and chp.chp_delete_flag=0
                                                and eml.eml_delete_flag=0'                       
                END

                execute sp_executesql @sql
GO

