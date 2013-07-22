require 'spec_helper'
describe ChallengesHelper do
  context 'questions types' do
    it 'has hash of all question types with lable=>value' do
      types = { 'Free Text' => 'text', 
                'Single Select' => 'single-select', 
                'Multiple Select' => 'multi-select'}
      question_types.should == types
    end
    
  end
  describe 'setup question' do
    
    describe 'should change' do
      it 'new record' do
        question = Question.new
        dup = question.clone
        setup_question(question)
        question.should_not == dup
      end
      describe 'with defined type' do
        ['text','single-select', 'multi-select'].each do |type|
          it "#{type}" do
            question = Question.new(:qtype => type)
            dup = question.dup
            setup_question(question)
            question.should_not == dup
          end
        end  
      end
    end
    describe 'should not change' do
      it 'text with options of first with content and selected' do
        question = FactoryGirl.build(:text_question)
        dup = question.clone
        setup_question(question)
        question.options.should == dup.options
        
        question.should be_type(dup.qtype)
        question.description.should == dup.description
      end
      
    end
    
  end
  
  describe 'init_type!' do
    before(:each) {@question = Question.new}
    
    it 'new record match type text' do
      init_type!(@question)
      @question.should be_type('text')
    end
    describe 'with predefined type' do
      ['text', 'single-select', 'multi-select'].each do |type|
        it "matches #{type}" do
          @question.qtype = type
          init_type!(@question)
          @question.should be_type(type)
        end
      end
      it 'matches text with invalid type' do
        @question.qtype = 'long'
        init_type!(@question)
        @question.should be_type('text')
      end
    end
  end
  describe 'set_text_options!' do
    
    context 'always size of 1' do
      [0, 1, 5].each do |number|
        it "starts with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new }
          set_text_options!(options)
          options.size.should == 1
        end
      end
    end
    
    context 'will be selected' do
      it 'come with selected' do
        options = [Option.new(:selected => true)]
        set_text_options!(options)
        options.first.should be_selected
      end
      it 'come without selected' do
        options = [Option.new]
        set_text_options!(options)
        options.first.should be_selected
      end
    end
    
    context 'will not change content' do
      ['', 'some content'].each do |content|
        it "with '#{content}'" do
          options = [Option.new(:content => content)]
          set_text_options!(options)
          options.first.content.should == content
        end
      end
    end
  end

  describe 'set_selection_options!' do
    context 'at least 5 options' do
      [0, 1, 5, 8].each do |number|
        it "start with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new }
          set_selection_options!(options)
          options.size.should >= 5
        end
      end
    end
    
    context 'fill with extract options if options < 5' do
      [0, 1, 4].each do |number|
        it "starts with #{number} options with content" do
          options = number.times.inject([]){|result| result << Option.new(content: 'content') }
          set_selection_options!(options)
          options.select{|o| o.content.blank?}.size.should == (5-number)
        end
      end
    end
    
    context 'no change if options >= 5' do
      [5, 8, 12].each do |number|
        it "starts with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new(content: 'content') }
          dup = options.dup
          set_selection_options!(options)
          options.should == dup
        end
      end
    end
    
  end
end
