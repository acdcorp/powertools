require 'action_view/helpers/javascript_helper'

module Apotomo
  module JavascriptMethods
    def modal(*args)
      content = render(*args)
      Apotomo.js_generator.send(:modal, content, *args)
    end

    def close_modals
      "bootbox.hideAll()"
    end
  end

  class JavascriptGenerator
    # Need to trigger page:change to turbolinks
    module Jquery
      def jquery;                 end
      def element(id);            "jQuery(\"#{id}\")"; end
      def update(id, markup);     element(id) + '.html("'+escape(markup)+'");$(document).trigger("page:change");'; end
      def replace(id, markup);    element(id) + '.replaceWith("'+escape(markup)+'");$(document).trigger("page:change");'; end
      def update_id(id, markup);  update("##{id}", markup); end
      def replace_id(id, markup); replace("##{id}", markup); end

      def modal(markup, args = {})
        options = {
          message: "#{markup}<script>$(document).trigger('page:change');</script>"
        }

        args.each do |key, value|
          next if [:action, :prefixes, :template, :layout].include? key
          options[key] = value
        end

        options[:buttons][:close] = {
          label: 'Close',
          className: 'btn-default'
        }

        "bootbox.dialog(#{options.to_json});"
      end
    end
  end
end
