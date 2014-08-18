class Owl
  SPEED = 50
  ROTATE_SPEED = 2.5

  def initialize
    @image = Image.new('images/brown-owl.jpg')
    @position = V[0, 0]
    @direction = V[1, 1]
    @rotation = 0
  end

  def update(elapsed, game)
    move(elapsed)
    bounce(game.display)
  end

  def move(elapsed)
    @position += @direction * SPEED * elapsed
    @rotation += ROTATE_SPEED * elapsed
  end

  def bounce(display)
    if @position.y < 0 || @position.y + @image.size.y > display.size.y
      @direction.y *= -1
    end

    if @position.x < 0 || @position.x + @image.size.x > display.size.x
      @direction.x *= -1
    end
  end

  def draw(d)
    d.push
      d.translate(@position)
      d.scale(V[Math.sin(@rotation) + 2, Math.sin(@rotation) + 2])
      d.rotate(@rotation)
      d.image_cropped(@image, V[-67.5, -40], V[80, 70], V[135, 80])
    d.pop
  end
end
