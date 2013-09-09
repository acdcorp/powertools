module Powertools
  class Engine < ::Rails::Engine
    isolate_namespace Powertools

    initializer "Powertools add to autoload", :group => :all do |app|
      app.config.autoload_paths += %W(#{app.config.root}/app/presenters)
      app.config.assets.paths << "#{Rails.root}/app/assets/plugins"
    end
  end
end
