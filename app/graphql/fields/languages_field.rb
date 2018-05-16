Fields::LanguagesField = GraphQL::Field.define do
  name 'Languages'
  type Types::LanguageType.connection_type

  resolve ->(obj, _args, _ctx) do
    LanguagesQuery.new.popular
  end
end
