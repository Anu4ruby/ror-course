class Question < ActiveRecord::Base
  default_scope :include => :options
  attr_accessible :qtype, :description, :created_by, :options_attributes
  has_many :options
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => proc { |option| option['content'].blank? }
  
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  validates :options, :presence => true
  # validate :options_duplicated?, :answer_picked?
  after_validation :correct_type?, :options_valid?, :answer_picked?
  
  def type?(type)
    qtype == type
  end
  def answers
    options.where('selected = ?', true)
  end
  def answers?(answers)
    self.answers.map(&:id) == [*answers].map { |a| a.to_i } 
  end
  
  def self.types
    { 'Free Text' => 'text', 
      'Single Select' => 'single-select', 
      'Multiple Select' => 'multi-select'}
  end
  #the optional questions save query time if it already been queried
  def self.check_answers(answers, questions = nil)
    answers.each_value { |ans| ans.delete_if {|item| item.blank?} }
    questions ||= Question.all
    data = { :wrong => 0, :pending => 0, :correct => 0, :detail => {} }
    data = questions.inject(data) do |hash, q|
      id_str = q.id.to_s
      cl =  if q.type?('text') && !answers[id_str].blank?
              'pending'
            else 
              q.answers?(answers[id_str]) ? 'correct' : 'wrong'
            end
      hash[cl.to_sym] += 1
      hash[:detail].merge!(q.id => cl)
      hash
    end
    data[:size] = questions.size
    data[:percentage] = self.get_percentage(data)
    data
  end
  
  def self.get_percentage(data)
    size = data[:size]
    correct = data[:correct]
    pending = data[:pending]
    ((correct.to_f / size)*100).round(2).to_s + " % "
  end
  
  private
  def answer_picked?
    if options.size < 0 || options.select { |o| o.selected? }.size < 1
      errors.add(:answer, "needs to be choosen")
      false
    else
      true
    end
  end
  
  def options_valid?
    size = options.size
    if size < 1
      errors.add(:options, "is required")
      return false 
    end
    if type?('text') && options.size != 1
      errors.add(:options, "should have only 1")
      return false
    end
    
    if options.size > options.map(&:content).uniq.size
      errors.add(:options, "has duplicate")
      return false 
    end
    true
  end
  
  def correct_type?
    return true if (!qtype.blank? && Question.types.has_value?(qtype))
    errors.add(:qtype, "is not correct question type")
    false
  end
  
  
end
