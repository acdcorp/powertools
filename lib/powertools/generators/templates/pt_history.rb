class PtHistory < ActiveRecord::Base

  belongs_to :creator, class_name: 'User'
  belongs_to :associated, polymorphic: true
  belongs_to :trackable, polymorphic: true
end
