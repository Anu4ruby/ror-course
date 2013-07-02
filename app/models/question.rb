class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :type
  has_many :answers
  has_many :choices
  validates :description, :presence => true
  validates :type, :presence => true
  validates :created_by, :presence => true
end
