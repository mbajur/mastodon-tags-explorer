Fields::InstancesField = GraphQL::Field.define do
  name 'Instances'
  type Types::InstanceType.connection_type

  resolve ->(_obj, _args, _ctx) do
    Instance.all
  end
end
