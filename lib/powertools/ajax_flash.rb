module Powertools::AjaxFlash
  extend ActiveSupport::Concern

  included do
    after_filter :flash_to_headers
  end

  def flash_to_headers
    if request.xhr?
      # Avoiding XSS injections via flash
      flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
      response.headers['X-Flash-Messages'] = flash_json
      flash.discard
    end
  end
end
