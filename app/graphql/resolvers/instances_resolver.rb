require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::InstancesResolver
  include SearchObject.module(:graphql)

  type Types::InstanceType.connection_type

  scope { Instance.all }

  option :order, type: Types::InstancesOrderEnumType, default: 'NAME'

  option :query, type: types.String do |scope, value|
    InstancesQuery.new(scope).search(value)
  end

  def apply_order_with_name(scope)
    InstancesQuery.new(scope).alphabetical
  end

  def apply_order_with_toots_count(scope)
    InstancesQuery.new(scope).popular
  end
end
