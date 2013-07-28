class Question < ActiveRecord::Base
  default_scope :include => :options
  attr_accessible :qtype, :description, :created_by, :options_attributes
  has_many :options
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => proc { |option| option['content'].blank? }
  
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  validates :options, :presence => true
  # validate :options_duplicated?, :answer_picked?
  def after_validation
    options_valid?
    answer_picked?
  end
  def type?(type)
    raise StandardError, 'Question type not set yet' if qtype.blank?
    qtype == type
  end
  def answers
    options.where('selected = ?', true)
  end
  def answers?(answers)
    self.answers.map(&:id) == [*answers].map{|a| a.to_i} 
  end
  # def eql_attr?(dup)
    # type?(dup.qtype) && description == dup.description && options == dup.options 
  # end
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
  
  def self.has_type?(type)
    !type.blank? && Question.types.has_value?(type)
  end
  
  def self.get_percentage(data)
    size = data[:size]
    correct = data[:correct]
    pending = data[:pending]
    ((correct.to_f / size)*100).round(2).to_s + " % "
  end
  
  private
  def answer_picked?
    selected = options.select { |o| o.selected? }.size
    if type?('multi-select')
      errors.add(:answer, "at least 1 choosen") unless selected >= 1
    elsif selected != 1
      errors.add(:answer, "needs to be choosen")
    end
  end
  
  def options_valid?
    if type?('text')
      errors.add(:options, "should have only 1")
    elsif options.size > options.map(&:content).uniq.size
      errors.add(:options, "has duplicate") 
    end
  end
  
end
