require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ChallengesHelper. For example:
#
# describe ChallengesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ChallengesHelper do
  context 'questions types' do
    it 'has hash of all question types with lable=>value' do
      question_types()
      true
    end
    
  end
  context 'setup question' do
    it 'should return a question of type "text"' do
      setup_question(Question.new)
      true
    end
    it 'should return a question of type "single-select"' do
      setup_question(Question.new(:qtype => 'single-select'))
      true
    end
    it 'should return a question of type "multi-select"' do
      setup_question(Question.new(:qtype => 'multi-select'))
      true
    end
  end
  
end
