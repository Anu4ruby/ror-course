class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :qtype, #:answers_attributes, :choices_attributes
  # has_many :answers
  # has_many :choices
  has_many :options
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  # validates :created_by, :presence => true
  accepts_nested_attributes_for :choices, :allow_destroy => true, :reject_if => proc { |choice| choice['description'].blank? }
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc { |answer| answer['description'].blank? && answer['choice_id'].blank? }
  def type?(type)
    if self.qtype.nil? && type == 'text'
      true
    else
      return self.qtype == type
    end
  end
end
