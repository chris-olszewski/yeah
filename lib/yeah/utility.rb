module Yeah::Utility
  # TODO: clean up this monster
  def self.make_file_structure(structure)
    make_recursively = lambda do |struct, base_loc=""|
      struct.each do |key, value|
        new_loc = "#{base_loc}#{key}"

        case value
        when Hash
          new_dir = "#{new_loc}/"
          Dir.mkdir(new_dir)
          make_recursively.call struct[key], new_dir
        when String
          File.open(new_loc, 'w') { |f| f.write(value) }
        end
      end
    end

    make_recursively.call structure
  end
end
