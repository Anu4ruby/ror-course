class VisitorQuestion < ActiveRecord::Base
  attr_accessible :description, :email, :respond
  validates :email, :presence => true
  validates :description, :presence => true
  validates :respond, :length => {:minimum => 2}, :allow_blank => true
  scope :not_respond, where(:respond => nil)
  scope :responded, where("respond !='' AND respond is not null").order('updated_at DESC')
end

