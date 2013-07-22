module ChallengesHelper
  def setup_question(question)
    init_type!(question)
    opts = question.options
    question.type?('text') ? set_text_options!(opts) : set_selection_options!(opts) 
    question
  end
  def init_type!(question)
    question.qtype = 'text' if !question_types.has_value?(question.qtype) 
  end
  def set_text_options!(options)
    opt = options.first
    opt.nil? ? (opt = Option.new(:selected => true)) : (opt.selected = true)
    options.clear << opt
  end
  def set_selection_options!(options)
    (5-options.size).times.inject(options){|result| result << Option.new}
  end
  def question_types
    {'Free Text' => 'text', 'Single Select' => 'single-select', 'Multiple Select' => 'multi-select'}
  end
  
  def check_answers(questions, answers)
    correct = 0
    pending = 0
    questions.each_with_index do |q, idx|
      if q.type?('text')
        pending += 1
        next
      end
      correct +=1 if q.check_answer(answers[q.id.to_s])
    end
    {:size => questions.size, :correct => correct, :pending => pending}
  end
end
