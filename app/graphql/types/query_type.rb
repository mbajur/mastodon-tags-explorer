Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :tagById, Fields::TagByIdField
  field :tagByName, Fields::TagByNameField
  field :instanceById, Fields::InstanceByIdField
  field :instanceByHost, Fields::InstanceByHostField
  field :languageByCode, Fields::LanguageByCodeField

  connection :tags, Fields::TagsField
  connection :instances, Fields::InstancesField
  connection :languages, Fields::LanguagesField
end
