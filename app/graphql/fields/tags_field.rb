Fields::TagsField = GraphQL::Field.define do
  name 'Tags'
  type Types::TagType.connection_type

  resolve ->(obj, _args, _ctx) do
    obj.present? ? obj.tags : Gutentag::Tag.all
  end
end
