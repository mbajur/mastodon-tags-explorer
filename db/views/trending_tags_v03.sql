select DISTINCT(gutentag_tags.id),
      gutentag_tags.name,
      gutentag_tags.created_at,
      gutentag_tags.updated_at,
      gutentag_tags.taggings_count,
      (
      select COUNT(*)
      from gutentag_taggings
      where gutentag_taggings.tag_id = gutentag_tags.id
      and gutentag_taggings.created_at::TIMESTAMPTZ AT TIME zone 'UTC' > now() - interval '6 hour'
    ) - (
      select COUNT(*)
      from gutentag_taggings
      where gutentag_taggings.tag_id = gutentag_tags.id
      and gutentag_taggings.created_at <= now()::TIMESTAMPTZ AT TIME zone 'UTC' - interval '6 hour'
      and gutentag_taggings.created_at > now()::TIMESTAMPTZ AT TIME zone 'UTC' - interval '12 hour'
    ) as hottness
from gutentag_tags
left join gutentag_taggings on gutentag_tags.id = gutentag_taggings.tag_id
where gutentag_taggings.created_at >= now()::TIMESTAMPTZ AT TIME zone 'UTC' - interval '12 hour'
and gutentag_tags.taggings_count > 5;
