require 'spec_helper'
describe ChallengesHelper do
  context 'questions types' do
    it 'has hash of all question types with lable=>value' do
      types = [['Free Text', 'text'],['Single Select', 'single-select'],['Multi Select', 'multi-select']]
      question_types().should == types
    end
    
  end
  context 'setup question' do
    context 'type of "text"' do
      before(:each) do
        @q = Question.new
        @q1 = setup_question(@q)
      end
      it 'should return a question of type "text"' do
        @q.qtype = 'text'
        @q1.should == @q
      end
      it 'should has only 1 option' do
        @q.options.new(:selected => true)
        @q1.options == @q.options
      end
    end
    context 'type of "single-select"' do
      before(:each) do
        @q = Question.new(:qtype => 'single-select')
        @q1 = setup_question(@q)
      end
      it 'should return a question of type "single-select"' do
        @q1.should == @q
      end
      it 'should has 5 empty options' do
        5.times{@q.options.new}
        @q1.options == @q.options
      end
    end
    context 'type of "multi-select"' do
      it 'should return a question of type "multi-select"' do
        setup_question(Question.new(:qtype => 'multi-select'))
        true
      end  
    end
    
  end
end
