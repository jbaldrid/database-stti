
/*	###RelationshipType Subscribers###	*/
DROP PROCEDURE [HRS].[client_stti_RelationshipType_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_RelationshipType_Subscribers] @Id nvarchar(80)
AS
SELECT
			eml.eml_address AS Email
	FROM
			co_email eml (NOLOCK)
			JOIN co_customer cst (NOLOCK) ON eml.eml_key=cst.cst_eml_key
			JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
			JOIN co_individual_x_organization ixo (NOLOCK) ON cst.cst_key=ixo.ixo_ind_cst_key
	WHERE
			cst.cst_delete_flag = 0
			AND cst.cst_eml_address_dn is NOT NULL
			AND ind.ind_deceased_flag=0
			AND eml.eml_invalid_flag=0
			AND eml.eml_address <> ''
			AND eml.eml_address is NOT NULL
			AND ixo.ixo_delete_flag=0
			AND ixo.ixo_rlt_code=@Id

GO

