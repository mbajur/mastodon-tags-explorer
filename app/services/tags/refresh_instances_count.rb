class Tags::RefreshInstancesCount
  attr_reader :tag

  def initialize(tag)
    @tag = tag
  end

  def call
    count = Instance.where(
      id: Toot.tagged_with(names: [tag.name]).select(:instance_id)
    ).count

    tag.update_attribute(:instances_count, count)
  end
end
