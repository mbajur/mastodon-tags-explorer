Types::InstanceType = GraphQL::ObjectType.define do
  name "Instance"

  field :id, !types.ID
  field :host, types.String

  connection :tags, Fields::TagsField
end
