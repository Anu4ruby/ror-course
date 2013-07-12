module ChallengesHelper
  def setup_question(question)
    if question.new_record?
      if question.qtype.nil?
        question.qtype = 'text' 
      end
      if !question.type?('text')
        (5-question.options.size).times { question.options.new()}
      else
        question.options.new(selected:true) 
      end
    end
    question
  end
  def question_types
    return [['Free Text', 'text'],['Single Select', 'single-select'],['Multi Select', 'multi-select']]
  end
end
