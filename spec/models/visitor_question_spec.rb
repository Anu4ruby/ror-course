require 'spec_helper'

describe VisitorQuestion do
  before(:each) do
    @q1 = VisitorQuestion.create(description:'what is ruby?', email:'abc@abc.com')
    @q2 = VisitorQuestion.create(description:'what is ruby on rails?', email:'abc1@abc.com')
    @q3 = VisitorQuestion.create(description:'what is rails?', email:'abc2@abc.com')
    @q4 = VisitorQuestion.create(description:'what is 1+1?', email:'abc@abc.com', respond:'it is 2')
  end
  it 'should only has not responded questions' do
    VisitorQuestion.not_respond.should == [@q1, @q2, @q3]
  end
  it 'should only has responded questions' do
    VisitorQuestion.responded.should == [@q4]
  end
end
