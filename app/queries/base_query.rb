class BaseQuery
  attr_reader :relation

  def initialize(relation = default_relation)
    @relation = relation
  end

  private

  def default_relation
    raise "default_relation is not defined for #{self.class.name}"
  end

  def es_client
    @es_client ||= Elasticsearch::Client.new log: true
  end
end
