class CreateTootWorker
  include Sidekiq::Worker

  def perform(host, id, language, tags, sensitive = false, created_at)
    instance = Instance.find_or_create_by(host: host)

    toot = instance.toots.find_or_create_by!(guid: id) do |toot|
      toot.language = language
      toot.tag_names = tags
      toot.created_at = created_at
      toot.sensitive = sensitive
    end

    # Refresh instances count
    toot.tags.each do |tag|
      Tags::RefreshInstancesCount.new(tag).call
    end
  end
end
