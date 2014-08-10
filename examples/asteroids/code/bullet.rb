class Bullet < Thing
  SPIN_SPEED = 0.6
  MAX_AGE = 0.5
  SPEED = 600

  def setup(args)
    @position = args.fetch(:position)
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
    @position.x += Math.cos(@direction) * SPEED * elapsed
    @position.y += Math.sin(@direction) * SPEED * elapsed
  end

  def wrap(game)
    left_overlap =  -@position.x - @size.x
    right_overlap =  @position.x - @size.x - game.display.width
    top_overlap =   -@position.y - @size.y
    bottom_overlap = @position.y - @size.y - game.display.height

    if left_overlap > 0
      @position.x = game.display.width + @size.x / 2 - left_overlap
    elsif right_overlap > 0
      @position.x = right_overlap - @size.x / 2
    end

    if top_overlap > 0
      @position.y = game.display.height + @size.y / 2 - top_overlap
    elsif bottom_overlap > 0
      @position.y = bottom_overlap - @size.y / 2
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
