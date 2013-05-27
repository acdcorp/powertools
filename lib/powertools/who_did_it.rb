module Powertools::WhoDidIt
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User'
    belongs_to :updater, class_name: 'User'

    before_create :add_creator
    before_update :add_updater
  end

  private

  def add_creator
    self.creator = User.current if(!self.creator_id && User.current)
  end

  def add_updater
    self.updater = User.current if User.current
  end
end
