require 'faye/websocket'
require 'eventmachine'
require 'logger'
require 'json'
require 'redis'
require 'raven'

hosts = ['mastodon.social', 'hcxp.co', 'photog.social', 'vis.social']
@listeners = {}

$logger = Logger.new(STDOUT)
$redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))

def start_listener(host)
  listener = @listeners[host.to_sym]
  listener = Faye::WebSocket::Client.new('wss://mastodon.social/api/v1/streaming/?stream=public')

  listener.on :open do
    $logger.info [:open, "Listening on #{host}"]
  end

  listener.on :message do |event|
    data = JSON.parse(event.data)

    case data['event']
    when 'update' then handle_update_event(data)
    when 'delete' then handle_delete_event(data)
    end
  end

  listener.on :close do |event|
    $logger.info [:close, event.code, event.reason]
    listener = nil
    raise "#{host} connection closed"
  end
end

def handle_update_event(data)
  payload = JSON.parse(data['payload'])
  return if payload['tags'].empty?

  $logger.info payload['url']
  host = URI.parse(payload['url']).host

  $logger.debug payload if host.nil?

  toot = OpenStruct.new(
    id: payload['id'],
    tags: payload['tags'].map { |t| t['name'] },
    created_at: payload['created_at'],
    sensitive: payload['sensitive'],
    language: payload['language'],
    host: host
  )

  msg = {
    class: 'CreateTootWorker',
    queue: 'default',
    args: [toot.host, toot.id, toot.language, toot.tags, toot.sensitive, toot.created_at],
    retry: false,
    jid: SecureRandom.hex(12),
    created_at: Time.now.to_f,
    enqueued_at: Time.now.to_f
  }
  $redis.lpush('queue:default', JSON.dump(msg))

  $logger.info [:message, toot]
  $logger.debug '--------------------------'
end

def handle_delete_event(data)
end

begin
  EM.run {
    hosts.each do |host|
      start_listener(host)
    end
  }
rescue => e
  Raven.capture_exception(e)
  raise(e)
end
