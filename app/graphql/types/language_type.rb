Types::LanguageType = GraphQL::ObjectType.define do
  name "Language"

  field :count, types.Int
  field :info, Types::LanguageInfoType

  connection :tags, Types::TagType.connection_type do
    resolve ->(obj, _args, _ctx) do
      TagsQuery.new.for_language(obj.info.iso_639_1)
    end
  end

  connection :instances, Types::InstanceType.connection_type do
    resolve ->(obj, _args, _ctx) do
      InstancesQuery.new.for_language(obj.info.iso_639_1)
    end
  end
end
