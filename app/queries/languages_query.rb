class LanguagesQuery < BaseQuery
  def trending
    resp = es_client.search index: 'toots', body: {
      query: {
        range: {
          created_at: {
            gte: 'now-2h'
          }
        }
      },
      aggregations: {
        significant_languages: {
          significant_terms: {
            field: 'language'
          }
        }
      }
    }

    mash = Hashie::Mash.new resp

    es_languages = mash.aggregations.significant_languages
    es_languages.buckets.map! do |bucket|
      bucket.record = LanguageList::LanguageInfo.find(bucket[:key])
      bucket
    end

    es_languages
  end

  def popular
    Toot.all
      .group(:language)
      .count
      .map { |l| { name: l[0], info: LanguageList::LanguageInfo.find(l[0]), count: l[1] } }
      .reject { |l| !l[:info].present? }
      .sort { |a, b| b[:count] <=> a[:count] }
  end

  private

  def default_relation
    nil
  end
end
