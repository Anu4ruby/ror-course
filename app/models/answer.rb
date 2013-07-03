class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :choice
  attr_accessible :description, :posted_by
end
