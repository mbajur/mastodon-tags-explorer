MastodonTagsExplorerSchema = GraphQL::Schema.define do
  default_max_page_size 25

  query(Types::QueryType)
end
