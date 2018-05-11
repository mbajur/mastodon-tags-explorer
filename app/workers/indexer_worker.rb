class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV.fetch('ELASTICSEARCH_URL', 'localhost:9200'), logger: Logger

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      record = Toot.find(record_id)
      Client.index  index: 'toots', type: 'toot', id: record.id, body: record.__elasticsearch__.as_indexed_json
    when /delete/
      Client.delete index: 'toots', type: 'toot', id: record_id
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
