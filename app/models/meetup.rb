class Meetup < ActiveRecord::Base
  belongs_to :creator, foreign_key: :meetup_creator_id , class_name: "User"  #:user, through: :meetup_creator
  has_many :meetup_members
  has_many :users, through: :meetup_members
  has_many :comments
end
