class Choice < ActiveRecord::Base
  belongs_to :question
  attr_accessible :description
  validates :description, :presence => true
  validates :question_id, :uniqueness => {:scope => :description}
end
