class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :type, :answers_attributes, :choices_attributes
  has_many :answers
  has_many :choices
  validates :description, :presence => true
  validates :type, :presence => true
  # validates :created_by, :presence => true
  accepts_nested_attributes_for :choices
  accepts_nested_attributes_for :answers
end
