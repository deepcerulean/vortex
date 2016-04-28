require 'dedalus'

require 'vortex/version'

require 'vortex/atoms/void'
require 'vortex/molecules/image_grid'
require 'vortex/templates/application_template'
require 'vortex/screens/application_screen'

require 'vortex/application_view'

module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView
  end

  class Server < Joyce::Server
  end
end
