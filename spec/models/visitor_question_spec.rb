require 'spec_helper'

describe VisitorQuestion do
  before(:each) do
    @not_responded = []
    @responded = []
    3.times{@not_responded << FactoryGirl.create(:visitor_question)}
    2.times{@responded << FactoryGirl.create(:responded_visitor_question)}
    3.times{@not_responded << FactoryGirl.create(:visitor_question)}
    2.times{@responded << FactoryGirl.create(:responded_visitor_question)}
    
  end
  it 'should only has not responded questions' do
    VisitorQuestion.not_respond.sort.should == @not_responded.sort
  end
  it 'should only has responded questions' do
    VisitorQuestion.responded.sort.should == @responded.sort
  end
end
