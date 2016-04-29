module Vortex
  class ImageGrid < Dedalus::Molecule
    include Dedalus::Elements

    attr_accessor :image_palette, :grid

    def show
      grid.map do |row|
        row.map do |grid_value|
          if grid_value
            image_for(grid_value)
          else
            no_image
          end
        end
      end
    end

    def image_for(grid_value)
      Icon.for(image_palette[grid_value])
    end

    def no_image
      Void.new
    end

    def self.description
      "a grid of images"
    end

    def self.example_data
      {
        image_palette: [ :house ],
        grid: [
          [ nil, 0, 0, 0 ],
          [ 0, nil, 0, 0 ],
          [ 0, 0, nil, 0 ],
          [ 0, 0, 0, nil ],
        ]
      }
    end
  end
end
