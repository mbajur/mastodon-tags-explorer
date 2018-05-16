Fields::RateLimitField = GraphQL::Field.define do
  name 'RateLimit'
  type Types::RateLimitType

  resolve ->(_obj, _args, ctx) do
    OpenStruct.new(ctx[:throttle_data]['graphql requests by ip'])
  end
end
