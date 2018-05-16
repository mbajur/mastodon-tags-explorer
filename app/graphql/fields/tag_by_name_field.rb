Fields::TagByNameField = GraphQL::Field.define do
  name 'Tag'
  type Types::TagType

  argument :name, !types.String

  resolve ->(_obj, args, _ctx) do
    Gutentag::Tag.find_by!(name: args[:name])
  end
end
