FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "password"
  end

  factory :question do
    sequence :description do |n|
       "challenge question #{n}"
    end
    factory :text_question do
      qtype 'text'
      ignore do
        options_count 1
      end
      before(:create) do |question, evaluator|
        # FactoryGirl.create_list(:option, evaluator.options_count, :question => question, :selected => true)
        (evaluator.options_count).times{ question.options.build(attributes_for(:option, :selected => true)) }
      end
      # after(:build) do |question, evaluator|
        # (evaluator.options_count).times{question.options.new(attributes_for(:option, :selected => true))}
      # end
    end
    factory :single_select_question do
      qtype 'single-select'
      ignore do
        options_count 5
      end
      before(:create) do |question, evaluator|
        question.options.build(attributes_for(:option, :selected => true))
        (evaluator.options_count-1).times{ question.options.build(attributes_for(:option)) }
      end
      after(:build) do |question, evaluator|
        # FactoryGirl.build_list(:option, evaluator.options_count, :question => question, :selected => true)
        (evaluator.options_count).times{question.options.new(attributes_for(:option))}
      end
    end
    factory :multi_select_question do
      qtype 'multi-select'
      ignore do
        options_count 5
      end
      before(:create) do |question, evaluator|
        question.options.build(attributes_for(:option, :selected => true))
        (evaluator.options_count-1).times{ question.options.build(attributes_for(:option)) }
      end
      after(:build) do |question, evaluator|
        # FactoryGirl.build_list(:option, evaluator.options_count, :question => question, :selected => true)
        (evaluator.options_count).times{question.options.new(attributes_for(:option))}
      end
    end
  end


  factory :option do
    question
    sequence :content do |n|
      "content #{n}"
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
      sequence :respond do |n|
        'admin responded #{n}'
      end
    end
  end
end