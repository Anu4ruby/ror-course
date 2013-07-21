require 'spec_helper'

describe Question do
  describe 'check type' do
    describe 'type should be match' do
      before(:each) do
        @question = Question.new
      end
      
      it 'empty recored' do
        @question.qtype.should be_nil
        @question.type?('text').should be_true
      end
      
      it 'assigns to text' do
        type = 'text'
        @question.qtype = type
        @question.type?(type).should be_true
      end
      
      it 'assigns to single-select' do
        type = 'single-select'
        @question.qtype = type
        @question.type?(type).should be_true
      end
      
      it 'assigns to multi-select' do
        type = 'multi-select'
        @question.qtype = type
        @question.type?(type).should be_true
      end
      
    end
    describe 'should not match' do
      before(:each) do
        @questions = [Question.new,
                      FactoryGirl.build(:text_question),
                      FactoryGirl.build(:single_select_question),
                      FactoryGirl.build(:multi_select_question)]
      end
      it 'text' do
        @questions.delete_if{|q| q.type? 'text'}
        @questions.each do |question|
          question.type?('text').should_not be true
        end
      end
      it 'single-select' do
        @questions.delete_if{|q| q.type? 'single-select'}
        @questions.each do |question|
          question.type?('single-select').should_not be true
        end
      end
      it 'multi-select' do
        @questions.delete_if{|q| q.type? 'text'}
        @questions.each do |question|
          question.type?('multi-slect').should_not be true
        end
      end
    end
    
  end
  context 'get answer(s)' do
    it 'for type text works' do
      q = FactoryGirl.create(:text_question)
      q.answers.to_a.should == q.options
    end
    
    it 'for type single select works' do
      q = FactoryGirl.create(:single_select_question)
      q.answers.should == [q.options.first]
    end
    
    it 'for type multi select works' do
      q = FactoryGirl.build(:multi_select_question)
      q.options.first(2).each do |opt|
        opt.selected = true
      end
      q.save
      q.answers.to_a.should == q.options.first(2)
    end
    
  end
  
  context 'check_answer' do
    before(:all) do
      @questions = [FactoryGirl.create(:text_question),
                    FactoryGirl.create(:single_select_question),
                    FactoryGirl.create(:multi_select_question)]
    end
    context 'should match' do
      it 'for text question' do
        q = @questions[0] 
        q.check_answer(q.answers).should be_true
      end
      
      it 'for single-select question' do
        q = @questions[0] 
        q.check_answer(q.answers).should be_true
      end
      
      it 'for text question' do
        q = @questions[0] 
        q.check_answer(q.answers).should be_true
      end
      
    end
    context 'should not match' do
      
    end
  end
  
end
