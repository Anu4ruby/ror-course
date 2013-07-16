class Option < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :selected
  validates :content, :uniqueness => {:scope => :question_id }
end
