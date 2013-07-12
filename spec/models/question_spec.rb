require 'spec_helper'

describe Question do
  context 'check type' do
    before(:each) do
      @questions = []
    end
    it 'should match type "text"' do
      q1 = Question.new(:qtype => 'text')
      q2 = Question.new
      q1.type?('text').should be true
      q2.type?('text').should be true
    end
    it 'should match type "multi-select"' do
      q1 = Question.new(:qtype => 'multi-select')
      q1.type?('multi-select').should be true
    end
    it 'should match type "single-select"' do
      q1 = Question.new(:qtype => 'single-select')
      q1.type?('single-select').should be true
    end
    it 'should not match type "text"' do
      @questions << Question.new(:qtype => 'multi-select')
      @questions << Question.new(:qtype => 'single-select')
      @questions.each do |question|
        question.type?('text').should_not be true
      end
    end
    it 'should not match type "multi-select"' do
      @questions << Question.new(:qtype => 'single-select')
      @questions << Question.new(:qtype => 'text')
      @questions << Question.new
      @questions.each do |question|
        question.type?('multi-select').should_not be true
      end
    end
    it 'should not match type "single-text"' do
      @questions << Question.new(:qtype => 'multi-select')
      @questions << Question.new(:qtype => 'text')
      @questions << Question.new
      @questions.each do |question|
        question.type?('single-text').should_not be true
      end
    end
  end
  context 'get answer(s)' do
    context 'type text' do
      it 'should be match' do
        q = FactoryGirl.create(:text_question)
        q.answers.to_a.should == Array(q.options)
        # true
      end
      it 'should not match' do
        true
      end
    end
    context 'type single select' do
      it 'should be match' do
        q = FactoryGirl.build(:single_select_question)
        q.options.first.selected = true
        q.save
        q.answers.to_a.should == Array(q.options.first)
        # true 
      end
    end
    context 'type multi select' do
      it 'should be match' do
        q = FactoryGirl.build(:multi_select_question)
        q.options.first(2).each do |opt|
          opt.selected = true
        end
        q.save
        q.answers.to_a.should == q.options.first(2)
      end
    end
    
  end
end
