class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :qtype, :options_attributes
  has_many :options
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => proc { |option| option['content'].blank? }
  before_validation :answer_picked
  def type?(type)
    if self.qtype.nil? && type == 'text'
      true
    else
      return self.qtype == type
    end
  end
  def answers
    # Option.where('selected = ? AND question_id = ?', true, self.id)
    self.options.where('selected = ?', true)
  end
  private
  def answer_picked
    if self.type?('multi-select')
      self.options.any? { |option| option.selected }
    else
      count = 0
      self.options.each do |option|
        if option.selected
          count += 1
        end
      end
      count == 1 ? true:false
    end
  end
end
