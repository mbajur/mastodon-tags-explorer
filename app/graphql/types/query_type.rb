Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :tagById, Fields::TagByIdField
  field :tagByName, Fields::TagByNameField
  field :instanceById, Fields::InstanceByIdField
  field :instanceByHost, Fields::InstanceByHostField
  field :languageByCode, Fields::LanguageByCodeField

  field :rateLimit, Fields::RateLimitField

  connection :tags, function: Resolvers::TagsResolver
  connection :instances, function: Resolvers::InstancesResolver
  connection :languages, Fields::LanguagesField
end
