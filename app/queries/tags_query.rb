class TagsQuery < BaseQuery
  def trending
    resp = es_client.search index: 'toots', body: {
      query: {
        range: {
          created_at: {
            gte: 'now-6h'
          }
        }
      },
      aggregations: {
        significant_tags: {
          significant_terms: {
            field: 'tag_names'
          }
        }
      }
    }

    mash = Hashie::Mash.new resp
    es_tags = mash.aggregations.significant_tags
    keys = es_tags.buckets.map { |t| t[:key] }
    tags = Gutentag::Tag.where(name: keys)

    es_tags.buckets.map! do |bucket|
      bucket.record = tags.detect { |t| t.name == bucket[:key] }
      bucket
    end

    es_tags
  end

  def popular
    relation.order(taggings_count: :desc)
  end

  def broad
    relation.order(instances_count: :desc)
  end

  def all
    relation.order(name: :asc)
  end

  def search(query)
    query = query.delete('#').downcase
    relation.where('name LIKE ?', "%#{query}%")
  end

  def for_language(code)
    relation
      .joins('INNER JOIN gutentag_taggings ON gutentag_tags.id = gutentag_taggings.tag_id')
      .joins('INNER JOIN toots ON gutentag_taggings.taggable_id = toots.id')
      .where('toots.language = ?', code)
      .order(taggings_count: :desc)
      .distinct
  end

  private

  def default_relation
    Gutentag::Tag.all
  end
end
