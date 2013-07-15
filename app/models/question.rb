class Question < ActiveRecord::Base
  attr_accessible :created_by, :description, :qtype, :options_attributes
  has_many :options
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  accepts_nested_attributes_for :options, :allow_destroy => true, 
            :reject_if => proc { |option| option['content'].blank? }
  validate :options_duplicated?, :answer_picked?
  def type?(type)
    if qtype.nil? && type == 'text'
      true
    else
      qtype == type
    end
  end
  def answers
    # Option.where('selected = ? AND question_id = ?', true, id)
    options.where('selected = ?', true)
  end
  def check_answer
    {correct: '', total: '', pending: ''}
  end
  private
  def answer_picked?
    if type?('multi-select')
      if !options.any? { |option| option.selected }
         errors.add(:answer, "pick one please")
      end
    else
      if options.select{|o| o.selected?}.size != 1
        errors.add(:answer, "pick one please")
      end
    end
  end
  def options_duplicated?
    errors.add(:options, "has duplicate options") if options.size > options.map(&:content).uniq.size
  end
end
