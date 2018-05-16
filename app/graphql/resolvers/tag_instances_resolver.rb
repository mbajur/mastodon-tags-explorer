require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::TagInstancesResolver
  include SearchObject.module(:graphql)

  type Types::InstanceType.connection_type

  scope do
    Instance
      .all
      .left_joins(:tags)
      .group(:id)
      .where('gutentag_tags.name = ?', object.name)
  end

  option :query, type: types.String do |scope, value|
    InstancesQuery.new(scope).search(value)
  end

  option :order, type: Types::InstancesOrderEnumType, default: 'NAME'

  def apply_order_with_name(scope)
    InstancesQuery.new(scope).alphabetical
  end

  def apply_order_with_toots_count(scope)
    scope.order('COUNT(gutentag_tags.id) DESC')
  end
end
