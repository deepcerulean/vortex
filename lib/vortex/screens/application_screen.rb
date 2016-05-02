module Vortex
  class ApplicationScreen < Dedalus::Screen
    include Dedalus::Elements

    attr_accessor :grid, :mouse_position, :player_location, :player_velocity

    def show
      layers
    end

    def layers
      layer_stack = Dedalus::LayerStack.new
      layer_stack.push(Dedalus::Layer.new(app_template))
      layer_stack.push(Dedalus::Layer.new(cursor, freeform: true))
      layer_stack
    end

    def cursor
      Icon.for(:arrow_cursor, position: mouse_position)
    end

    def app_template
      ApplicationTemplate.new(
        greeting: greeting,
        grid: grid,
        player_location: player_location,
        player_velocity: player_velocity
          # [25 - (Gosu::milliseconds / 1200.0),9]
      )
    end

    def greeting
      "Hello there!"
    end
  end
end
