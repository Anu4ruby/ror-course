module ChallengesHelper
  def setup_question(question)
    init_type!(question)
    # question.type?('text') ? set_text_options!(question.options) : set_selection_options!(question.options)
    question.options =  if question.type?('text')
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
    options + (5-options.size).times.inject([]) { |result| result << Option.new }
  end
  
  def output_stat(data)
    return "" unless [:pending, :size, :percentage] - data.keys == []
    content_tag(:div) do
      concat content_tag(:span, "score: #{ data[:percentage] }")
      concat content_tag(:span, "pending: #{ data[:pending]} / #{data[:size] }")
    end
  end
end
