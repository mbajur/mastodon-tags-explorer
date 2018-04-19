class CreateTootWorker
  include Sidekiq::Worker

  def perform(host, id, language, tags)
    instance = Instance.find_or_create_by(host: host)

    toot = instance.toots.find_or_create_by!(guid: id) do |toot|
      toot.language = language
      toot.tag_names = tags
    end

    # Refresh instances count
    toot.tags.each do |tag|
      Tags::RefreshInstancesCount.new(tag).call
    end
  end
end
