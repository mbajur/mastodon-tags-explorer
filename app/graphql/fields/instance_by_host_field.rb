Fields::InstanceByHostField = GraphQL::Field.define do
  name 'Instance'
  type Types::InstanceType

  argument :host, !types.String

  resolve ->(_obj, args, _ctx) do
    Instance.find_by!(host: args[:host])
  end
end
