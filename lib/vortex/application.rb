module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView

    def setup(*)
      # create a world!
      fire(create_world)
      # fire(generate_map)
      sim.params[:active_player_id] ||= player_id
    end

    def player_id
      @player_id ||= SecureRandom.uuid
    end

    private
    def create_world
      CreateWorldCommand.create(world_id: world_id, name: "Hello")
    end

    def world_id
      @world_id ||= SecureRandom.uuid
    end

  end
end
