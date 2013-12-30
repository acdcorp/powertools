require 'action_view/helpers/javascript_helper'

module Apotomo
  class JavascriptGenerator
    # Need to trigger page:change to turbolinks
    module Jquery
      def jquery;                 end
      def element(id);            "jQuery(\"#{id}\")"; end
      def update(id, markup);     element(id) + '.html("'+escape(markup)+'");$(document).trigger("page:change");'; end
      def replace(id, markup);    element(id) + '.replaceWith("'+escape(markup)+'");$(document).trigger("page:change");'; end
      def update_id(id, markup);  update("##{id}", markup); end
      def replace_id(id, markup); replace("##{id}", markup); end
    end
  end
end
