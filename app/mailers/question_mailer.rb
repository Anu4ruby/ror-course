class QuestionMailer < ActionMailer::Base
  default :from => "sadicarnot@gmail.com"

  def responded(question)
    # @user = user
    # @url = "http://localhost.com:3000/users/login"
    # mail(:to => user.email, :subject => "Welcome to MySite")
    @question = question
    mail(:to => question.email, :subject => "Your question has been answered", :from => "sadicarnot@gmail.com")
  end
end