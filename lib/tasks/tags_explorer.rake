namespace :tags_explorer do
  task :listen => :environment do
    # wss://mastodon.social/api/v1/streaming/?stream=public

    require 'faye/websocket'
    require 'eventmachine'
    require 'json'

    include ActionView::Helpers::SanitizeHelper

    SOURCES = [
      # 'wss://mastodon.social/api/v1/streaming/?stream=public',
      'wss://photog.social/api/v1/streaming/?stream=public',
    ].freeze

    SOURCES.each do |source|
      EM.run {
        ws = Faye::WebSocket::Client.new(source)

        ws.on :open do |event|
          p "Listening on #{source}"
        end

        ws.on :message do |event|
          data = JSON.parse(event.data)
          next if data['event'] != 'update'

          payload = JSON.parse(data['payload'])
          content = payload['content']
          content = strip_tags(content)
          tags = content.scan(/#(\w+)/).flatten

          pp(
            event: data['event'],
            language: payload['language'],
            tags: tags,
          )
        end

        ws.on :close do |event|
          p [:close, event.code, event.reason]
          ws = nil
        end
      }
    end
  end
end
