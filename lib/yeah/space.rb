module Yeah

class Space < Base
  def initialize(properties = {})
    properties.each do |key, val|
      writer = "#{key}="
      send(writer, val)
    end
  end

  # Background color.
  #
  # @return [Color]
  def background
    @background ||= Color[]
  end
  def background=(value)
    @background = Color[value]
  end

  # Active things.
  #
  # @return [Array]
  def things
    @things ||= []
  end
  def things=(value)
    # Convert representative hash to thing instances.
    if value.respond_to?(:to_h)
      new_things = []

      value.to_h.each do |type_name, positions|
        type = Kernel.const_get(type_name)
        positions = [positions] unless positions.first.respond_to?(:to_a)

        positions.each do |position|
          new_things << type.new(position)
        end
      end

      value = new_things
    end

    @things = value
    @things.each { |t| t.space = self }
  end

  def game
    @game ||= Game.new
  end
  def game=(value)
    @game = value
    @game.space = self unless game.space == self
  end

  def update
    things.each(&:update)
  end
end

end