module Vortex
  class ApplicationScreen < Dedalus::Screen
    include Dedalus::Elements

    attr_accessor :grid

    def show
      app_template.show
    end

    def app_template
      ApplicationTemplate.new(
        greeting: greeting,
        image_palette: [ :house ],
        grid: grid
      )
    end

    def greeting
      "Hello there!"
    end
  end
end
