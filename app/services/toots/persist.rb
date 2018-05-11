class Toots::Persist
  attr_reader :toot

  def initialize(toot)
    @toot = OpenStruct.new(toot)
  end

  def call
    client.index(
      index: 'toots',
      type: 'toot',
      body: {
        id: toot.id,
        host: toot.host,
        sensitive: toot.sensitive,
        tags: toot.tags,
        language: toot.language,
        created_at: toot.created_at || Time.zone.now
      }
    )
  end

  private

  def client
    @client ||= Elasticsearch::Client.new log: true
  end
end
