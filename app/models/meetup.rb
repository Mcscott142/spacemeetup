class Meetup < ActiveRecord::Base
  belongs_to :meetup_creator #:user, through: :meetup_creator
  has_many :users, through: :meetup_members
end
