class InstancesQuery < BaseQuery
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
        significant_instances: {
          significant_terms: {
            field: 'instance.host'
          }
        }
      }
    }

    mash = Hashie::Mash.new resp
    es_instances = mash.aggregations.significant_instances
    keys = es_instances.buckets.map { |t| t[:key] }
    instances = Instance.where(host: keys)

    es_instances.buckets.map! do |bucket|
      bucket.record = instances.detect { |t| t.host == bucket[:key] }
      bucket
    end

    es_instances
  end

  def popular
    relation
      .left_joins(:tags)
      .group(:id)
      .order('COUNT(gutentag_tags.id) DESC')
  end

  def alphabetical
    relation.order(host: :asc)
  end

  def search(query)
    relation.search(query)
  end

  def for_language(code)
    relation
      .joins(:toots)
      .where('toots.language = ?', code)
      .distinct
  end

  private

  def default_relation
    Instance.all
  end
end
