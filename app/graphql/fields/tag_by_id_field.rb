Fields::TagByIdField = GraphQL::Field.define do
  name 'Tag'
  type Types::TagType

  argument :id, !types.ID

  resolve ->(_obj, args, _ctx) do
    Gutentag::Tag.find(args[:id])
  end
end
