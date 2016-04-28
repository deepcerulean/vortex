module Vortex
  class Void < Dedalus::Atom
    def render(*); end

    def self.description
      'an empty space'
    end

    def self.example_data
      {}
    end

    def width; icon_example.width end
    def height; icon_example.height end

    def icon_example
      Dedalus::Elements::Icon.for(:house)
    end
  end
end
