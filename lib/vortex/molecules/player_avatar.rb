module Vortex
  class PlayerAvatar < Dedalus::Molecule #Elements::Sprite #Dedalus::Molecules
    attr_accessor :name, :velocity, :overlay_color, :position

    # TODO permit layout of 'freeform' components...
    def elements
      [ player_sprite, Dedalus::Elements::Paragraph.new(text: name) ]
    end

    def player_sprite
      # p [ :player_position, position ]
      Dedalus::Elements::Sprite.new(
        path: path,
        frame: frame,
        invert_x: invert_x,
        overlay_color: overlay_color,
        width: 64,
        height: 64
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
  end
end
