module TestHelper
  # for login user
  def set_user(user=nil)
    if !user.nil?
      set_current_user(user)
      set_user_signed_in(true)  
    else
      set_user_signed_in(false)
    end
  end
  def clear_user
    set_current_user(nil)
    set_user_signed_in
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
  
  def set_current_user(user)
    controller.stub(:current_user).and_return(user)
    # controller.should_receive(:current_user).at_least(0).times.and_return(user)
  end
  def set_user_signed_in(confirm=false)
    controller.stub(:user_signed_in?).and_return(confirm)
    # controller.should_receive(:user_signed_in).at_least(0).times.and_return(confirm)
  end
  
  # these code works if it states in spec file
  #   let(:current_user){FactoryGirl.create(:admin)}
  #   let(:user_signed_in?){return true}
  #   # if not concern of using current_user and user_signed_in, ignore above  
  #   before(:each) do
  #     controller.should_receive(:authorize_user!).at_least(0).times.and_return(nil)
  #   end
  def pass_authorize
    controller.should_receive(:authorize_user!).at_least(0).times.and_return(nil)
  end
  # shortcut for factory girl
  # # factorygirl create
  # def fgc(symbol, options={})
    # FactoryGirl.create(symbol.to_sym, options)
  # end
  # # factorygirl build
  # def fgb(symbol, options={})
    # FactoryGirl.build(symbol.to_sym, options)
  # end
  # # factorygirl attributes_for
  # def fga(symbol, options={})
    # FactoryGirl.attributes_for(symbol.to_sym, options)
  # end
  def method_missing(meth, *args, &block)
    if m = meth.to_s.match(/^fg([abc])$/)
      case m[1]
      when 'a'
        FactoryGirl.attributes_for(*args, &block)
      when 'b'
        FactoryGirl.build(*args, &block)
      when 'c'
        FactoryGirl.create(*args, &block)
      end
    else
      super
    end
  end
end