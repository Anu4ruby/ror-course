module TestHelper
  # for login user
  def set_user(user=nil)
    if !user.nil?
      controller.stub(:current_user).and_return(user)
      controller.stub(:user_signed_in?).and_return(true)  
    else
      controller.stub(:user_signed_in?).and_return(false)
    end
  end
  def clear_user
    controller.stub(:current_user).and_return(nil)
    controller.stub(:user_signed_in?).and_return(false)
  end
  
  #login alternative
  def login_user
    user = FactoryGirl.create(:user)
    set_user(user)
    user
  end
  def login_admin
    admin = FactoryGirl.create(:admin)
    set_user(admin)
    admin
  end
  #login best way, not tested
  def has_user
    user = FactoryGirl.create(:user)
    should_receive(:current_user).and_return(user)
    should_receive(:user_signed_in?).and_return(true)
  end
  def has_admin
    admin = FactoryGirl.create(:admin)
    should_receive(:current_user).and_return(admin)
    should_receive(:user_signed_in?).and_return(true)
  end
end