module Vortex
  class ApplicationTemplate < Dedalus::Template
    include Dedalus::Elements

    attr_accessor :greeting, :grid, :scale, :player_views # :player_location, :player_velocity

    def show
      layout { play_field }
    end

    def play_field
      PlayField.new(
        grid: grid,
        # player_location: player_location,
        # player_velocity: player_velocity,
        scale: scale,
        player_views: player_views
      )
    end

    def layout
      [
        Heading.new(text: greeting),
        yield
      ]
    end

    def self.description
      'base vortex game template'
    end

    def self.example_data
      {
        greeting: 'hi',
        grid: [[ 0, 1, 2, nil],
               [ nil, 0, 1, 2]],
        scale: 0.3,
        player_views: [{ location: [3, 0], velocity: [0,0] }]
      }
    end
  end
end
