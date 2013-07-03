class Choice < ActiveRecord::Base
  belongs_to :question
  attr_accessible :description
  validates :description, :presence => true
end
