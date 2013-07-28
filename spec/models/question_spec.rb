require 'spec_helper'

describe Question do
  let(:text) { fgc(:text_question) }
  let(:single) { fgc(:single_select_question) }
  let(:multiple) { fgc(:multi_select_question) }
  
  describe 'validation' do
    it 'description is required' do
      Question.create().should have(1).error_on(:description)
      Question.create(:description => 'yea').should have(0).error_on(:description)
    end
    it 'qtype is required' do
      Question.create().should have(1).error_on(:description)
      Question.create(:qtype => 'text').should have(0).error_on(:qtype)
    end
  end
  context 'questions types' do
    it 'has hash of all question types with lable=>value' do
      types = { 'Free Text' => 'text', 
                'Single Select' => 'single-select', 
                'Multiple Select' => 'multi-select'}
      Question.types.should == types
    end
  end
  
  describe 'check type' do
    context 'empty record' do
      it 'should raise error' do
        lambda{Question.new.type?('text')}.should raise_error(StandardError)
      end
    end
    describe 'with type' do
      subject { FactoryGirl.build(:question, :qtype => type)}
      
      ['text', 'single-select','multi-select'].each do |attr|
        let(:type) { attr }
        it "#{attr} matches" do
          subject.type?(type).should be_true
        end
      end
    end
    
    describe 'should not match' do
      let(:questions) {[text, single, single, multiple, multiple]}
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
      let(:questions) { [text, single, multiple, single, multiple, single] }
      ['text', 'single-select','multi-select'].each do |attr|
        it "#{attr}" do
          q = questions.shift
          q.answers.should == [*q.options.first]
        end
      end
    end
  end
  
  context 'check answers' do
    let(:questions) { [text, single, multiple, single, multiple, single] }
    context 'should match' do
      ['text', 'single-select','multi-select'].each do |attr|
        it "for #{attr}" do
          q = questions.shift
          q.answers?(q.answers.map(&:id)).should be_true
        end
      end
      # => at this point the questions should be empty
    end
    context 'should not match' do
      ['text', 'single-select','multi-select'].each do |attr|
        it "#{attr}" do
          qs = questions.reject{ |q| !q.type?(attr) }
          q = (questions - qs).first
          qs.each do |question|
            q.answers?(question.answers.map(&:id)).should_not be true
          end
        end
      end                        
    end
  end
  
  describe 'check all answers' do
    before(:each) do
      fgc(:text_question)
      fgc(:single_select_question)
      fgc(:multi_select_question)
    end
    it 'should work' do
      qs = Question.all
      texts = Question.where(:qtype => 'text')
      answers = qs.inject({}) { |r,q| r.merge(q.id.to_s => q.answers.map(&:id))}
      data = Question.check_answers(answers, qs) 
      data[:size].should == qs.size
      data[:pending].should == texts.map(&:id)
      data[:correct].should == (qs - texts).map(&:id)
    end
    it 'returns hash with keys [:size, :pending, :correct]' do
      data = Question.check_answers({})
      data.keys.sort.should == [:size, :pending, :correct].sort
    end
  end

  describe 'has_type?' do
    ['text', 'single-select', 'multi-select'].each do |type|
      it "has type #{type.inspect}" do
        Question.should be_has_type(type)
      end
    end
    [nil, '', 'not_valid_type'].each do |type|
      it "has no type #{type.inspect}" do
        Question.should_not be_has_type(type)
      end
    end
  end
  
  # this include answer_picked and options_valid
  describe 'after_validation' do
    let(:qs) { [text, single, multiple] }
    ["text", "single-select", "multi-select"].each_with_index do |type, idx|
      describe do
        let(:q) { qs[idx] }
        it "answer picked for type #{type} " do
          q.after_validation
          q.errors.full_messages.should_not be_include("Answer needs to be choosen")
          q.errors.full_messages.should_not be_include("Answer at least 1 choosen")
        end
        
        it "fails: answer not picked for #{type}" do
          q.options.first.selected = false
          q.after_validation
          q.errors.should be_has_key(:answer)
        end
        
        it "has no duplicate options for type #{type}" do
          q.after_validation
          q.errors.full_messages.should_not be_include("has duplicate options")
        end
        
        it "fails: has duplicate options for type #{type}" do
          q.options[1] = q.options[0]
          q.after_validation
          q.errors.should be_has_key(:options)
          if type == 'text'
            q.errors.full_messages.should be_include("Options should have only 1")
          else
            q.errors.full_messages.should be_include("Options has duplicate")
          end
        end
      end
    end
  end
end
