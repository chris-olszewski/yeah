class Ship < Thing
  COLOR = C['#ffff88']
  SPEED = 5
  ROTATE_SPEED = 5

  def setup(args)
    @size = V[32, 32]
    @velocity = V[0, 0]
    @direction = Math::PI * 1.5
    @args = args
  end

  def update(elapsed, game)
    control(elapsed, game)
    move(elapsed, game)
    wrap(game)
    collide(game)
  end

  def control(elapsed, game)
    @direction += ROTATE_SPEED * elapsed if game.input[:right]
    @direction -= ROTATE_SPEED * elapsed if game.input[:left]
    @thrusting = game.input[:up]

    if game.input[:shoot]
      game.things << Bullet.new(position: @position, direction: @direction)
    end
  end

  def move(elapsed, game)
    if @thrusting
      @velocity.x += Math.cos(@direction) * SPEED * elapsed
      @velocity.y += Math.sin(@direction) * SPEED * elapsed
    end

    @position += @velocity
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

  def _wrap(game)
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

        initialize(@args)
        return
      end
    end
  end

  def draw(d)
    d.stroke_color = COLOR

    d.push
      d.translate @position
      d.rotate @direction + Math::PI / 2
      d.translate -@size / 2

      d.begin_shape
        d.move_to V[@size.x / 2, 0]
        d.line_to V[@size.x, @size.y]
        d.line_to V[@size.x / 2, @size.y / 2]
        d.line_to V[0, @size.y]
        d.line_to V[@size.x / 2, 0]
      d.end_shape
      d.stroke_shape

      if @thrusting
        d.begin_shape
          d.move_to V[@size.x / 2, @size.y / 2]
          d.line_to V[@size.x / 2, @size.y]
        d.end_shape
        d.stroke_shape
      end
    d.pop
  end
end
