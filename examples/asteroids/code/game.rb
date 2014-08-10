class AsteroidsGame < Game
  BG_COLOR = C['#001133']

  attr_accessor :input, :things

  def setup
    @things = []
    @things << Ship.new(position: display.size / 2)
    6.times do
      @things << Asteroid.new(position: V[Math.rand * display.width,
                                          Math.rand * display.height],
                              side_count: 6)
    end

    @input = {}

    @shot = false

    display.stroke_color = C['#dddddd']
    display.stroke_width = 4
    display.fill_color = BG_COLOR
  end

  def update(elapsed)
    @input[:left] = keyboard.pressing? :left
    @input[:right] = keyboard.pressing? :right
    @input[:up] = keyboard.pressing? :up

    if keyboard.pressing?(:z) && !@shot
      @input[:shoot] = true
      @shot = true
    else
      @input[:shoot] = false
    end

    @shot = false unless keyboard.pressing?(:z)

    display.clear

    @things.each do |t|
      next if t.nil? # TODO: obviate w/ sturdier solution
      t.update(elapsed, self)
      t.draw(display)
    end
  end
end
