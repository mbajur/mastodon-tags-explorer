Types::TagType = GraphQL::ObjectType.define do
  name 'Tag'

  field :id, !types.ID
  field :name, types.String
  field :taggingsCount, types.Int, property: :taggings_count
  field :instancesCount, types.Int, property: :instances_count

  connection :instances, function: Resolvers::TagInstancesResolver
end
