select
  parent_tags.id,
  parent_tags.name,
  parent_tags.created_at,
  parent_tags.updated_at,
  parent_tags.taggings_count,
  parent_tags.instances_count,
  (
    SELECT COUNT(*)
    FROM "toots"
    WHERE ("toots"."id" IN (SELECT "gutentag_taggings"."taggable_id" FROM "gutentag_taggings" INNER JOIN "gutentag_tags" ON "gutentag_tags"."id" = "gutentag_taggings"."tag_id" WHERE "gutentag_taggings"."taggable_type" = 'Toot' AND "gutentag_tags"."name" = parent_tags.name))
    and toots.created_at >= now()::TIMESTAMPTZ AT TIME zone 'UTC' - interval '2 weeks'
  ) as count_all,
  (
    SELECT COUNT(*)
    FROM "toots"
    WHERE ("toots"."id" IN (SELECT "gutentag_taggings"."taggable_id" FROM "gutentag_taggings" INNER JOIN "gutentag_tags" ON "gutentag_tags"."id" = "gutentag_taggings"."tag_id" WHERE "gutentag_taggings"."taggable_type" = 'Toot' AND "gutentag_tags"."name" = parent_tags.name))
    and toots.created_at >= now()::TIMESTAMPTZ AT TIME zone 'UTC' - interval '1 hour'
  ) as count_recent
from
  gutentag_tags as parent_tags
