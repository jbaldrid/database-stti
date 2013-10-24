/*           ###State Subscribers###             */
DROP PROCEDURE [HRS].[client_stti_State_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_State_Subscribers] @Id nvarchar(40)
AS
SELECT  
                                eml.eml_address AS Email
                FROM
                                co_email eml (NOLOCK)
                                JOIN co_customer cst (NOLOCK) ON cst.cst_eml_key=eml.eml_key
                                JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
                                JOIN co_customer_x_address cxa (NOLOCK) ON cxa.cxa_key=cst.cst_cxa_key
                                JOIN co_address adr (NOLOCK) ON adr.adr_key=cxa.cxa_adr_key
                                
                WHERE
                                cst.cst_delete_flag=0
                                and cst.cst_eml_address_dn is NOT NULL
                                and eml.eml_invalid_flag=0
                                and eml.eml_delete_flag=0
                                and eml.eml_address <> ''
                                and eml.eml_address is NOT NULL
                                and ind.ind_deceased_flag=0
                                and ind.ind_delete_flag=0
                                and cxa.cxa_delete_flag=0
                                and adr.adr_delete_flag=0
                                and adr.adr_state=@Id
GO
