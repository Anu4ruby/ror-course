class UserMailer < ActionMailer::Base
  default :from => "sadicarnot@gmail.com"

  def welcome_email(user)
     
    mail(:to => user.email, :subject => "Registered", :from => "anu4ruby@gmail.com")

  end

end