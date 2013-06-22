class UserMailer < ActionMailer::Base
  default :from => "sadicarnot@gmail.com"

  def welcome_email(user)
    # @user = user
    # @url = "http://localhost.com:3000/users/login"
    # mail(:to => user.email, :subject => "Welcome to MySite")
    mail(:to => user.email, :subject => "Registered", :from => "sadicarnot@gmail.com")

  end

end