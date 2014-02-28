require 'opal'

module Yeah
Web::Server = Rack::Builder.new do
  map '/' do
    run Player.new
  end

  map '/assets' do
    run Assets.new
  end

  class Player
    include Yeah

    def call(env)
      [200, { 'Content-Type' => 'text/html' }, [html]]
    end

    def html
      player_path = "#{PATH}/lib/yeah/web/player.html"
      player_template = File.read(player_path)
      params = {
        game_name: game_class_name,
        game_assets: game_assets,
        initializer: initializer
      }

      player_template % params
    end

    def game_assets
      script_paths = Dir.glob('**/*.rb')
      formatting = "  %s\n"

      script_paths.inject("") do |markup, script_path|
        element = "<script src=\"/assets/#{script_path}\"></script>"
        formatted_element = formatting % element
        markup << formatted_element
      end.chomp
    end

    def initializer
      element = "<script>\n%s</script>"
      initializer = <<-ruby
        $document.ready do
          #{game_class_name}.new(Yeah::Web::Context.new)
        end
      ruby
      compiled_initializer = Opal.compile(initializer)

      element % compiled_initializer
    end

    # TODO: Improve
    def game_class_name
      require 'yeah/utility/project'

      Yeah::Project.new.game_class_name
    end
  end

  class Assets < Opal::Environment
    def initialize(*args)
      super

      use_gem 'paggio'
      #use_gem 'opal-browser'
      opal_browser_dir = Gem::Specification.find_by_name('opal-browser').gem_dir
      append_path File.join(opal_browser_dir, 'opal')
      use_gem 'yeah'
      append_path '.'

      puts self.instance_variable_get(:@assets)
    end
  end
end
end