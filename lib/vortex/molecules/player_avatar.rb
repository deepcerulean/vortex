module Vortex
  class PlayerAvatar < Dedalus::Molecule #Elements::Sprite #Dedalus::Molecules
    attr_accessor :name, :velocity, :overlay_color, :position

    def show
      elements
    end

    def hover
      puts "---> hover player"
    end

    def click
      puts "---> click player"
    end

    attr_accessor :highlight
    def hover
      p [ :hover_player!, name: name ]
      self.highlight = true
    end

    # TODO permit layout of 'freeform' components...
    def elements
      [ player_sprite, Dedalus::Elements::Paragraph.new(text: name) ]
    end

    def player_color
      clr = Dedalus::Palette.decode_color(overlay_color || 'white')
      if self.highlight
        clr.lighten.lighten
      else
        clr.darken
      end
    end

    def player_sprite
      # p [ :player_position, position ]
      Dedalus::Elements::Sprite.new(
        path: path,
        frame: frame,
        invert_x: invert_x,
        overlay_color: player_color, # overlay_color,
        asset_width: 64,
        asset_height: 64,
        scale: 2.0
      )
    end

    def path
      "media/images/walk.png"
    end

    def invert_x
      vx,_ = *velocity
      vx > 0
    end

    def frame
      if velocity == [0,0]
        0
      else
        1 + (Gosu::milliseconds / 150 % 4)
      end
    end

    def self.description
      "a player character"
    end

    def self.example_data
      { name: "Bob", velocity: [2,1], overlay_color: 'blue' }
    end
  end
end
