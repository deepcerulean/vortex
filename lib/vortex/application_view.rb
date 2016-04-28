module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(grid: map)
    end

    def map #(w,h)
      @map ||= create_map(20,20)
    end
    
    def create_map(w,h)
      Array.new(w) do
        Array.new(h) do
          rand > 0.5 ? 0 : nil
        end
      end
    end
  end
end
