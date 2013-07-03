module ChallengesHelper
  def setup_question(question)
    if question.new_record?
      if question.answers.size == 0
        question.answers.new
      end
      if question.qtype.nil?
        question.qtype = 'text' 
      end
      if !question.type?('text')
        5.times { question.choices.new }
      end
    end
    return question
  end
  def question_types
    return [['Free Text', 'text'],['Multi Select', 'multi-select'],['Single Select', 'single-select']]
  end
end
