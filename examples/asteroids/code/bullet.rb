class Bullet < Thing
  SPIN_SPEED = 0.6
  MAX_AGE = 0.5
  SPEED = 600

  def initialize(args)
    super

    @direction = args.fetch(:direction)

    @size = V[8, 8]
    @age = 0
  end

  def update(elapsed, game)
    move(elapsed)
    wrap(game)
    collide(game)
    self_destruct(elapsed, game)
  end

  def move(elapsed)
    @position.along! @direction, SPEED * elapsed
  end

  def wrap(game)
    half_size = @size / 2

    if (left_overlap = -@position.x - half_size.x) > 0
      @position.x = game.display.width - left_overlap + half_size.y
    elsif (right_overlap = @position.x - half_size.x - game.display.width) > 0
      @position.x = right_overlap - half_size.y
    end

    if (top_overlap = -@position.y - half_size.y) > 0
      @position.y = game.display.height - top_overlap + half_size.y
    elsif (bottom_overlap = @position.y - half_size.y - game.display.height) > 0
      @position.y = bottom_overlap - half_size.y
    end
  end

  def collide(game)
    game.things.each do |thing|
      if thing.respond_to?(:colliding?) && thing.colliding?(@position)
        thing.die(game)

        game.things.reject! { |t| t == self }
        return
      end
    end
  end

  def self_destruct(elapsed, game)
    @age += elapsed

    if @age > MAX_AGE
      game.things.reject! { |t| t == self }
    end
  end

  def draw(d)
    d.stroke_color = Ship::COLOR

    d.push
      d.translate(@position)
      d.rotate(0.785 + @direction)
      d.stroke_rectangle(@size / -2, @size)
    d.pop
  end
end
