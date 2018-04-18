class CreateTootWorker
  include Sidekiq::Worker

  def perform(host, id, language, tags)
    instance = Instance.find_or_create_by(host: host)

    instance.toots.find_or_create_by!(guid: id) do |toot|
      toot.language = language
      toot.tag_names = tags
    end
  end
end
