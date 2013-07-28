module TestHelper
  def set_current_user(user)
    subject.stub(:current_user).and_return(user)
  end
  
  def set_user_signed_in(confirm=false)
    subject.stub(:user_signed_in?).and_return(confirm)
  end
  
  def clear_user
    set_current_user(nil)
    set_user_signed_in
  end
  
  # for login user
  def set_user(user=nil)
    if user.nil?
      set_user_signed_in(false)
    else
      set_current_user(user)
      set_user_signed_in(true)
    end
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
  
  # give admin permission if it states in spec file
  #   let(:current_user) { FactoryGirl.create(:admin) }
  #   let(:user_signed_in?) { true }
  # if not concern of using current_user? and user_signed_in?, use bellow  
  def pass_authorize
    subject.should_receive(:authorize_user!).at_least(0).times.and_return(nil)
  end
  
  # shortcut for factory girl
  def method_missing(meth, *args, &block)
    if m = meth.to_s.match(/^fg([abc])$/)
      case m[1]
      when 'a' #attributes_for
        FactoryGirl.attributes_for(*args, &block)
      when 'b' #build
        FactoryGirl.build(*args, &block)
      when 'c' #create
        FactoryGirl.create(*args, &block)
      end
    else
      super
    end
  end
end