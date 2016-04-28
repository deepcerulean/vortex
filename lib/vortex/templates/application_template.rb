module Vortex
  class ApplicationTemplate < Dedalus::Template
    include Dedalus::Elements

    attr_accessor :greeting, :image_palette, :grid

    def show
      layout do
        image_grid
      end
    end

    def layout
      [
        Heading.new(text: greeting),
        yield
      ]
    end

    def image_grid
      ImageGrid.new(image_palette: image_palette, grid: grid)
    end

    def self.description
      'base vortex game template'
    end

    def self.example_data
      {
        greeting: 'hi'
      }.merge(ImageGrid.example_data)
    end
  end
end
