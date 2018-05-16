require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::TagsResolver
  include SearchObject.module(:graphql)

  type Types::TagType.connection_type

  OrderEnum = GraphQL::EnumType.define do
    name 'TagsOrder'

    value 'COUNT'
    value 'INSTANCES_COUNT'
    value 'NAME'
  end

  scope do
    object.present? ? object.tags : Gutentag::Tag.all
  end

  option :query, type: types.String do |scope, value|
    TagsQuery.new(scope).search(value)
  end

  option :order, type: OrderEnum, default: 'NAME'

  def apply_order_with_name(scope)
    TagsQuery.new(scope).all
  end

  def apply_order_with_count(scope)
    TagsQuery.new(scope).popular
  end

  def apply_order_with_instances_count(scope)
    TagsQuery.new(scope).broad
  end
end
