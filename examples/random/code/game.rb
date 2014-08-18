class RandomGame < Game
  attr_reader :image, :position

  # Make #d an alias for #display.
  alias :d :display

  def setup
    @owl = Owl.new
    @paused = false
  end

  def update(elapsed)
    # Pause after pressing 'p'.
    @paused = !@paused if keyboard.pressed? :p
    return if @paused

    # Clear display.
    d.fill_color = C['#936']
    d.clear

    # Draw assorted shapes and text.
    draw_assorted_shapes_and_text

    # Update & draw owl.
    @owl.update(elapsed, self)
    @owl.draw(display)
  end

  def draw_assorted_shapes_and_text
    # Draw random text.
    d.fill_color = C['#fedcba']
    d.stroke_color = C['#abcdef']
    d.stroke_width = 1.5
    d.font_size = 54
    d.fill_text("Wuzzuzzuzuuzuzuzuzuzu", V[150, 50])

    # Draw a square, filled and outlined.
    d.fill_color = C['#630']
    d.stroke_color = C['#ff0000']
    d.stroke_width = 5
    d.fill_rectangle(V[300, 300], V[100, 100])
    d.stroke_rectangle(V[300, 300], V[100, 100])

    # Draw a thick line.
    d.stroke_color = C['#eee']
    d.stroke_width = 20
    d.stroke_line(V[700, 700], V[935, 666])

    # Draw an irregular shape.
    d.begin_shape
      d.move_to V[600, 600]
      d.curve_to V[1000, 500], V[700, 700]
      d.curve2_to V[837, 181], V[500, 500], V[300, 300]
      d.line_to V[300, 300]
    d.end_shape
    d.stroke_color = C['#990']
    d.stroke_width = 8
    d.fill_color = C['#099']
    d.stroke_shape
    d.fill_shape

    # Draw a target.
    d.fill_color = C['#907050']
    d.fill_ellipse(V[200, 200], V[36, 36])
    d.stroke_color = C['#507090']
    d.stroke_ellipse(V[200, 200], V[24, 24])
    d.stroke_ellipse(V[200, 200], V[12, 12])
  end
end
