FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end
    password "password"
    confirmed_at Time.now
    
    factory :admin do
      is_admin true
    end
  end

  factory :question do
    sequence :description do |n|
       "challenge question #{n}"
    end
    factory :text_question do
      qtype 'text'
      after(:build) do |question, evaluator|
        question.options.build(attributes_for(:option, :selected => true))
      end
    end
    factory :question_with_options do
      ignore do
        options_count 5
      end
      # create goes after build, therefore after(:build) is better than before(:create)
      after(:build) do |question, evaluator|
        question.options.build(attributes_for(:option, :selected => true))
        (evaluator.options_count-1).times{ question.options.build(attributes_for(:option)) }
      end
      factory :single_select_question do
        qtype 'single-select'
      end
      factory :multi_select_question do
        qtype 'multi-select'
      end  
    end
    
  end


  factory :option do
    question
    sequence :content do |n|
      "option content #{n}"
    end
  end

  factory :visitor_question do
    sequence :description do |n|
      "question ask \##{n}"
    end
    sequence :email do |n|
      "ask#{n}@example.com"
    end
    factory :responded_visitor_question do
      updated_at (Time.now + 1000)
      sequence :respond do |n|
        'admin responded #{n}'
      end
    end
  end
end