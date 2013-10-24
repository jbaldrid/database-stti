CREATE PROCEDURE HRS.client_stti_MemberTypes_Segments
AS
		
	SELECT
		mbt_description AS Name,
		mbt_code AS Id
	FROM
		mb_member_type (NOLOCK)
		JOIN mb_member_type_ext (NOLOCK) ON mbt_key_ext = mbt_key
	WHERE
		mbt_delete_flag = 0
		AND mbt_community_flag_ext = 0
		AND mbt_chapter_flag = 0