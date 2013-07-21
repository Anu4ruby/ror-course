require 'spec_helper'

describe Question do
  describe 'check type' do
    context 'empty recored' do
      it 'should raise error' do
        lambda{Question.new.type?('text')}.should raise_error(StandardError, 'Question type not set yet')
      end
    end
    describe 'should be match with type of' do
      subject { FactoryGirl.build(:question, :qtype => type)}
      
      ['text', 'single-select','multi-select'].each do |attr|
        let(:type) { attr }
        it "#{attr}" do
          subject.type?(type).should be_true
        end
      end
    end
    
    describe 'should not match' do
      let(:questions) {[FactoryGirl.build(:text_question),
                        FactoryGirl.build(:single_select_question),
                        FactoryGirl.build(:multi_select_question)]}
                        
      ['text', 'single-select','multi-select'].each do |attr|
        it "#{attr}" do
          questions.delete_if{|q| q.type? attr}
          questions.each do |question|
            question.type?(attr).should_not be true
          end
        end
      end                        
      
    end
    
  end
  
  describe 'get answers' do
    describe 'works of type' do
      let(:questions) {[FactoryGirl.create(:text_question),
                        FactoryGirl.create(:single_select_question),
                        FactoryGirl.create(:multi_select_question)]}
                        
      ['text', 'single-select','multi-select'].each do |attr|
        it "#{attr}" do
          q = questions.shift
          q.answers.should == [*q.options.first]
        end
      end
    end
  end
  
  context 'check answers' do
    before(:all) do
      @text = FactoryGirl.create(:text_question)
      @single = FactoryGirl.create(:single_select_question)
      @multiple = FactoryGirl.create(:multi_select_question)
      @questions = [@text, @single, @multiple]
    end
    context 'should match' do
      let(:questions) { @questions}
      
      ['text', 'single-select','multi-select'].each do |attr|
        it 'for #{attr}' do
          q = questions.shift
          q.answers?(q.answers).should be_true
        end
      end
      # => at this point the questions should be empty
    end
    context 'should not match' do
      ['text', 'single-select','multi-select'].each do |attr|
        it "#{attr}" do
          qs = @questions.reject{ |q| !q.type?(attr) }
          q = (@questions - qs).first
          qs.each do |question|
            q.answers?(question.answers).should_not be true
          end
        end
      end                        
    end
  end
  
end
