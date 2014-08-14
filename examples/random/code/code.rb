require 'math'

class ExampleGame < Game
  SPEED = 50
  ROTATE_SPEED = 2.5

  alias :d :display

  def setup
    @image = Image.new('images/brown-owl.jpg')
    @position = V[0, 0]
    @direction = V[1, 1]
    @rotation = 0

    d.font_size = 54
  end

  def update(elapsed)
    d.fill_color = C['#993366']
    d.clear

    d.fill_color = C['#fedcba']
    d.stroke_color = C['#abcdef']
    d.stroke_width = 1.5
    d.text(V[150, 50], "Wuzzuzzuzuuzuzuzuzuzu")

    d.fill_color = C['#663300']
    d.stroke_color = C['#ff0000']
    d.stroke_width = 5
    d.fill_rectangle(V[300, 300], V[100, 100])
    d.stroke_rectangle(V[300, 300], V[100, 100])

    d.stroke_color = C['#eeeeee']
    d.stroke_width = 20
    d.line(V[700, 700], V[935, 666])

    d.begin_shape
      d.move_to V[600, 600]
      d.line_to V[300, 300]
      d.line_to V[837, 181]
    d.end_shape
    d.stroke_color = C['#999900']
    d.stroke_width = 8
    d.fill_color = C['#009999']
    d.stroke_shape
    d.fill_shape

    d.push
      d.translate(@position)
      d.scale(V[Math.sin(@rotation) + 2, Math.sin(@rotation) + 2])
      d.rotate(@rotation)
      d.image_cropped(@image, V[-67.5, -40], V[80, 70], V[135, 80])
    d.pop
    @position += @direction * SPEED * elapsed
    @rotation += ROTATE_SPEED * elapsed

    if @position.y < 0 || @position.y + @image.size.y > d.size.y
      @direction.y *= -1
    end

    if @position.x < 0 || @position.x + @image.size.x > d.size.x
      @direction.x *= -1
    end
  end
end
