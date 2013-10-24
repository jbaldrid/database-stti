/*	###Mailing List Subscribers###	*/
DROP PROCEDURE [HRS].[client_stti_NKIPresenceEvent_Subscribers]
GO

CREATE PROCEDURE [HRS].[client_stti_NKIPresenceEvent_Subscribers] @Id nvarchar(50)
AS
SELECT
		eml.eml_address AS Email
	FROM
		co_email eml (NOLOCK)
		JOIN co_customer cst (NOLOCK) ON eml.eml_key=cst.cst_eml_key
		JOIN co_individual ind (NOLOCK) ON cst.cst_key=ind.ind_cst_key
		JOIN client_stti_nki_presence_event_x_co_customer n04 (NOLOCK) ON cst.cst_key=n04.n04_cst_key
	WHERE
		cst.cst_delete_flag = 0
		AND cst.cst_eml_address_dn is NOT NULL
		AND ind.ind_deceased_flag=0
		AND eml.eml_invalid_flag=0
		AND eml.eml_address <> ''
		AND eml.eml_address is NOT NULL
		AND n04.n04_delete_flag=0
		AND n04.n04_n03_key=@Id
GO