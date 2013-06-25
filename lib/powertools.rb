class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

# class String
#   def is_number?
#     true if Float(self) rescue false
#   end
# end

require 'powertools/engine'
require 'powertools/nav'
require 'powertools/respond_to'
require 'powertools/current_user'
require 'powertools/who_did_it'
require 'powertools/ajax_flash'
require 'powertools/history_tracker'
require 'powertools/form'
require 'powertools/generators/history_tracker_generator'

module Powertools
end
