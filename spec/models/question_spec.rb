require 'spec_helper'
#fg => FactoryGirl, a => attribute_for, b => build, c => create
describe Question do
  let(:text) { fgb(:text_question) }
  let(:single) { fgb(:single_select_question) }
  let(:multiple) { fgb(:multi_select_question) }
  
  describe 'validation' do
    context 'question type is required' do
      let(:q) { Question.new(:qtype => type) }
      before(:each) { q.save }
      context 'without type' do
        let(:type) { nil }
        it 'errors on qtype' do
          q.errors.should be_has_key(:qtype)
          q.errors.full_messages.should be_include("Qtype can't be blank")
        end
      end
      context 'with type' do
        let(:type) { 'text' }
        it 'no errors on qtype' do
          q.errors.should_not be_has_key(:qtype)
        end
      end
    end
    context 'description is required' do
      let(:q) { Question.new(:qtype => type, :description => desc) }
      let(:type) { 'text' }
      before(:each) { q.save }
      context 'with description' do
        let(:desc) { 'description' }
        it 'no errors on description' do
          q.errors.should_not be_has_key(:description)
        end
      end
      context 'without description' do
        let(:desc) { "" }
        it 'errors on description' do
          q.errors.should be_has_key(:description)
          q.errors.full_messages.should be_include("Description can't be blank")
        end
      end
    end
  end
  describe 'after_validation' do
    let(:qs) { [text, single, multiple] }
    ["text", "single-select", "multi-select"].each_with_index do |type, idx|
      describe do
        let(:q) { qs[idx] }
        it "answer picked for type #{type} " do
          q.save.should be_true
          q.errors.full_messages.should_not be_include("Answer needs to be choosen")
        end
        
        it "fails: answer not picked for #{type}" do
          q.options.first.selected = false
          q.save.should_not be_true
          q.errors.should be_has_key(:answer)
        end
        
        it "has no duplicate options for type #{type}" do
          q.save.should be_true
          q.errors.full_messages.should_not be_include("has duplicate options")
        end
        
        it "fails: has duplicate options for type #{type}" do
          q.options[1] = q.options[0]
          q.save.should_not be_true
          q.errors.should be_has_key(:options)
          if type == 'text'
            q.errors.full_messages.should be_include("Options should have only 1")
          else
            q.errors.full_messages.should be_include("Options has duplicate")
          end
        end
        
        it 'fails: without any options' do
          q.options = []
          q.save
          q.errors.should be_has_key(:options)
          q.errors.full_messages.should be_include("Options is required")
        end
      end
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
    describe 'with type' do
      subject { FactoryGirl.build(:question, :qtype => type)}
      
      ['text', 'single-select','multi-select'].each do |attr|
        let(:type) { attr }
        it "fails with empty record when matching #{attr}" do
          Question.new.type?(attr)
        end
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
          q.save!
          q.answers.should == [*q.options.first]
        end
      end
    end
  end
  
  context 'answers?' do
    let(:questions) { [text, single, multiple, single, multiple, single] }
    context 'should match' do
      ['text', 'single-select','multi-select'].each do |attr|
        it "for #{attr}" do
          q = questions.shift
          q.save!
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
          q.save!
          qs.each do |question|
            q.answers?(question.answers.map(&:id)).should_not be true
          end
        end
      end                        
    end
  end
  
  describe 'check answers' do
    let(:qs) { Question.all }
    let(:texts) { Question.where(:qtype => 'text') }
    let(:selections) { qs - texts }
    let(:answers) { qs.inject({}) { |r,q| r.merge(q.id.to_s => q.answers.map(&:id))} }
    let(:data) { Question.check_answers(answers, qs) }
    let(:keys) { [:wrong, :size, :pending, :correct, :detail, :percentage] }
    let(:sizes) { { :size => qs.size,
                    :pending => texts.size,
                    :correct => selections.size, 
                    :wrong => 0,
                    :detail => qs.size } }
    before(:each) do
      5.times { fgc(:text_question) }
      8.times { fgc(:single_select_question) }
      3.times { fgc(:multi_select_question) }
    end
    
    context 'hash keys' do
      it { data.keys.sort.should == keys.sort }
    end
    
    [:size, :pending, :correct, :wrong].each do |sym|
      context "number for #{sym}" do
        it { data[sym].should == sizes[sym] }
      end
    end
    context 'size for detail items' do
      it { data[:detail].size.should == sizes[:detail] }
    end
    context 'percentage' do
      it { data[:percentage].should == Question.get_percentage(data) }
    end
  end
  
end
