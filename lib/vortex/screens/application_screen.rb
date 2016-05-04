module Vortex
  class ApplicationScreen < Dedalus::Screen
    include Dedalus::Elements

    attr_accessor :grid, :mouse_position, :active_player_name, :player_views

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
        player_views: player_views
      )
    end

    def greeting
      "Hello #{active_player_name}!"
    end
  end
end
