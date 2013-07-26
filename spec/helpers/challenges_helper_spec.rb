require 'spec_helper'
describe ChallengesHelper do
  
  describe 'setup question' do
    def dup_question(question)
      q = Question.new
      q.qtype = question.qtype
      q.description = question.description
      q.options = question.options
      q
    end
    
    describe 'new record' do
      before(:each) do
        @question = Question.new
        setup_question(@question)
      end
      it 'should change to type text' do
        @question.should be_type('text')
      end
      it 'should has 1 option' do
        @question.options.should have(1).items
      end
    end
    describe 'with defined type' do
      ['text','single-select', 'multi-select'].each do |type|
        describe "#{type}" do
          before(:each) do
            @question = Question.new(:qtype => type)
            setup_question(@question)
          end
          it 'should not change type' do
            @question.should be_type(type)
          end
          it 'should not change description' do
            @question.description.should be_blank
          end
          num = type == 'text' ? 1 : 5
          it "should have #{num} options" do
            @question.options.should have(num).items
          end
          describe 'and defined options' do
            [0, 1, 5].each do |idx|
              describe "of #{idx}" do
                before(:each) do
                  @options = idx.times.inject([]) { |result| result << Option.new(:content => 'some content')}
                  @question.options = @options
                  setup_question(@question)
                end
                it "match #{idx} options" do
                  @options.should have(idx).items
                end
                it "it should be type #{type}" do
                  @question.should be_type(type)
                end
                it "should have #{num} options" do
                  @question.options.should have(num).items
                end
                blank_num = type == 'text' ? idx == 0 ? 1 : 0 : 5-idx
                it "should have #{ blank_num } blank options" do
                  @question.options.select{|o| o.content.blank? }.should have(blank_num).items
                end
              end
            end
            
          end
        end
      end
    end
    describe 'with defined options only' do
      [1, 4, 5, 7].each do |size|
        describe "of size #{size}" do
          before(:each) do
            @question = Question.new
            @question.options = size.times.inject([]){ |result| result << Option.new(:content => 'yea')}
            setup_question(@question)
          end
          it 'should be type text' do
            @question.should be_type('text')
          end
          it 'should have only 1 option' do
            @question.options.should have(1).items
          end
          it 'option should be selected' do
            @question.options.first.should be_selected
          end
          it 'option should not change' do
            @question.options.first.content.should == 'yea'
          end
        end
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
          options.should have(1).items
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
    before(:each){@question = Question.new}
    context 'at least 5 options' do
      [0, 1, 5, 8].each do |number|
        it "start with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new }
          set_selection_options!(options)
          options.should have_at_least(5).items
        end
      end
    end
    
    context 'fill up to 5 options if options < 5' do
      [0, 1, 4].each do |number|
        it "starts with #{number} options with content" do
          options = number.times.inject([]){|result| result << Option.new(content: 'content') }
          @question.options = options
          set_selection_options!(options)
          opts = @question.options
          set_selection_options!(opts)
          options.select{|o| o.content.blank?}.should have(5-number).items
          @question.options.select{|o| o.content.blank?}.should have(5-number).items
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
  describe 'output_stat' do
    it 'rendered' do
      data = {:size => 10, :correct => (1..6).to_a, :pending => (7..10).to_a}
      output_stat(data).should =~ /div.*span/
    end
    it 'raise error' do
      data = {}
      lambda{output_stat(data)}.should raise_error(StandardError, "data not correct")
    end
  end
  describe 'check_answers' do
    it 'should work' do
      FactoryGirl.create(:text_question)
      FactoryGirl.create(:single_select_question)
      FactoryGirl.create(:multi_select_question)
      qs = Question.all
      answers = qs.inject({}) { |r,q| r.merge(q.id.to_s => q.answers.map(&:id))}
      data = check_answers(qs, answers) 
      data.should == {:pending => [1], :correct => [2]}
    end
  end
end
