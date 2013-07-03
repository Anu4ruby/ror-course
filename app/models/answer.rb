class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :choice
  attr_accessible :description, :posted_by, :choice_id
  validates :choice_id, :uniqueness => {:scope => :question_id}
end
