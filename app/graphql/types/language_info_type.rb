Types::LanguageInfoType = GraphQL::ObjectType.define do
  name "LanguageInfo"

  field :name, types.String
  field :iso_639_1, types.String
  field :iso_639_2b, types.String
  field :iso_639_2t, types.String
  field :iso_639_3, types.String
  field :common, types.Boolean, property: :common?
end
