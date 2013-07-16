require 'spec_helper'

describe QuestionMailer do
  before(:each) do
    @question = FactoryGirl.create(:responded_visitor_question)
    @mail = QuestionMailer.responded(@question)
  end
  it 'renders the subject' do
    @mail.subject.should == 'Your question has been answered'
    # true
  end
  it 'renders the sender email' do
    @mail.from.should == ['info@ror-course.com']
    # true
  end
  it 'renders the receiver email' do
    @mail.to.should == [@question.email]
    # true
  end
  it 'assigned show_ask_url(@question)' do
    @mail.body.encoded.should =~ /#{ask_url(@question)}/
    # true
  end
end
