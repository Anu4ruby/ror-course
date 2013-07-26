module ChallengesHelper
  def setup_question(question)
    init_type!(question)
    question.type?('text') ? set_text_options!(question.options) : set_selection_options!(question.options) 
    question
  end
  def init_type!(question)
    question.qtype = 'text' if !type_matches?(question.qtype)
  end
  def set_text_options!(options)
    opt = options.first
    opt.nil? ? (opt = Option.new(:selected => true)) : (opt.selected = true)
    options.clear << opt
  end
  def type_matches?(type)
    !type.blank? && Question.types.has_value?(type)
  end
  def set_selection_options!(options)
    (5-options.size).times{ options << Option.new}
  end
  
  def check_answers(questions, answers)
    answers.each_value {|ans| ans.delete_if {|item| item.blank?} }
    data = questions.inject({:pending => [], :correct => []}) do |hash, q|
      id_str = q.id.to_s
      if q.type?('text') && !answers[id_str].blank?
        hash[:pending] << q.id
      else
        hash[:correct] << q.id if q.answers?(answers[id_str])
      end
      
      hash
    end
    data[:size] = questions.size
    data
  end
  
  def output_stat(data)
    # data = check_answers(questions, answers)
    size = data[:size]
    correct = data[:correct].size
    pending = data[:pending].size
    result = number_with_precision((correct.to_f / size)*100, :precision => 2)+" % "
    
    content_tag(:div) do
      concat content_tag(:span, "score: #{result}")
      concat content_tag(:span, "pending: #{pending} / #{size}")
    end
    
  end
end
