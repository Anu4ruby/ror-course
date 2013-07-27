module ChallengesHelper
  def setup_question(question)
    init_type!(question)
    # question.type?('text') ? set_text_options!(question.options) : set_selection_options!(question.options)
    question.options = if question.type?('text')
      set_text_options(question.options)
    else
      set_selection_options(question.options)
    end
    question
  end
  
  def init_type!(question)
    question.qtype = 'text' if !question_type?(question.qtype)
  end
  
  def question_type?(type)
    !type.blank? && Question.types.has_value?(type)
  end
  
  def set_text_options(options)
    opt = options.first
    if opt.nil?
      [Option.new(:selected => true)]
    else
      opt.selected = true
      [opt]
    end
  end
  
  def set_selection_options(options)
    options + (5-options.size).times.inject([]){ |result| result << Option.new}
  end
  
  def output_stat(data)
    return "" if !(data.keys.sort == [:pending, :correct, :size].sort)
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
