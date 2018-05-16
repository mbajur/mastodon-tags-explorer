Fields::LanguageByCodeField = GraphQL::Field.define do
  name 'Language'
  type Types::LanguageType

  argument :code, !types.String

  resolve ->(_obj, args, _ctx) do
    Hashie::Mash.new(
      info: LanguageList::LanguageInfo.find(args[:code])
    )
  end
end
