Fields::InstanceByIdField = GraphQL::Field.define do
  name 'Instance'
  type Types::InstanceType

  argument :id, !types.ID

  resolve ->(_obj, args, _ctx) do
    Instance.find(args[:id])
  end
end
