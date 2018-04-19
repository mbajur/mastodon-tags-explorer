select DISTINCT(gutentag_tags.id),
      gutentag_tags.name,
      gutentag_tags.created_at,
      gutentag_tags.updated_at,
      gutentag_tags.taggings_count,
      gutentag_tags.instances_count,
      (
      select COUNT(*)
      from gutentag_taggings
      where gutentag_taggings.tag_id = gutentag_tags.id
      and gutentag_taggings.created_at::timestamp > now() - interval '3 hour'
    ) as count_current,
    (
      select COUNT(*)
      from gutentag_taggings
      where gutentag_taggings.tag_id = gutentag_tags.id
      and gutentag_taggings.created_at <= now()::timestamp - interval '3 hour'
      and gutentag_taggings.created_at > now()::timestamp - interval '12 hour'
    ) as count_old
from gutentag_tags
left join gutentag_taggings on gutentag_tags.id = gutentag_taggings.tag_id
where gutentag_taggings.created_at >= now()::timestamp - interval '12 hours'
and gutentag_tags.taggings_count > 5;
