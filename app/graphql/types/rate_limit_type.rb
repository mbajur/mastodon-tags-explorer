Types::RateLimitType = GraphQL::ObjectType.define do
  name "RateLimit"

  field :count, types.Int
  field :period, types.Int
  field :limit, types.Int
end
