class PtHistory < ActiveRecord::Base
  include Powertools::WhoDidIt

  # We are using WhoDidIt
  # belongs_to :creator
  belongs_to :associated, polymorphic: true
  belongs_to :trackable, polymorphic: true
end
