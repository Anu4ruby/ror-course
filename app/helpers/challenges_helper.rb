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
    [['Free Text', 'text'],['Single Select', 'single-select'],['Multi Select', 'multi-select']]
  end
  
  def page_items(collection, page, page_size = 10)
    pages = (collection.size/page_size + 1).to_i
    p '...............................'
    p page
    
    if page.between?(1, pages)
      start_idx = (page - 1) * page_size
      end_idx = start_idx + page_size
      if page < pages
        collection[start_idx...end_idx]
      else
        collection[start_idx..-1]
      end
      
    else
      []
    end
    
  end
  # module_function :page
end
