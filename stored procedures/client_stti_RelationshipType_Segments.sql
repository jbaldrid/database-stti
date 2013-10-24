
/*	###RelationshipType Segments###	*/
DROP PROCEDURE [HRS].[client_stti_RelationshipType_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_RelationshipType_Segments]
AS
SELECT
		rlt_code as Name,
		rlt_code as Id

	FROM
		co_relationship_type (NOLOCK) 
	WHERE
		rlt_delete_flag=0
		AND rlt_type='Ind_Org'

GO
