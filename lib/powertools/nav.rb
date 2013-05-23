require 'singleton'

module Powertools
  class Nav
    include Singleton

    class << self
      def config &block
        # Make the current presenter the context
        @items = @presenter.instance_eval &block
      end

      def items presenter
        @presenter = presenter
        # TODO: move this to initializer so it's only ever ran once
        path = Rails.root.join 'config', 'pt_nav.rb'
        Rails.load(path) if File.exist? path
        @items || []
      end
    end
  end
end
