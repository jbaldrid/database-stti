/*           ###CHAPTER POSITION Segments###   */
DROP PROCEDURE [HRS].[client_stti_ChapterPosition_Segments]
GO

CREATE PROCEDURE [HRS].[client_stti_ChapterPosition_Segments]
AS
SELECT
                                cpo_description AS Name,
                                cpo_code AS Id
                FROM
                                mb_committee_position (NOLOCK)
                WHERE
                                cpo_delete_flag = 0
                                AND len(cpo_code) > 0
                                AND cpo_description is NOT NULL
                                and cpo_chapter_flag=1
GO
