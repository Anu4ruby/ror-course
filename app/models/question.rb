class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :qtype, :answers_attributes, :choices_attributes
  has_many :answers
  has_many :choices
  validates :description, :presence => true
  validates :qtype, :presence => true
  # validates :created_by, :presence => true
  accepts_nested_attributes_for :choices
  accepts_nested_attributes_for :answers
  def type?(type)
    if self.qtype.nil? && type == 'text'
      true
    else
      return self.qtype == type
    end
  end
end
