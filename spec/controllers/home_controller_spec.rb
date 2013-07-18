require 'spec_helper'

describe HomeController do
  render_views
  describe "Authorization" do
    after(:each) do
      clear_user
    end
    describe "when visiting the ror-course page" do

      describe "for non-signed-in users" do
        it 'ask for sign in' do
          set_user
          get :ror
          response.should redirect_to new_user_session_url
          # response.body.should have_content "sign in first"
          flash[:notice].should have_content "sign in first"
        end
      end

      describe "for users signed-in" do
  
        before(:each) do
          @user = FactoryGirl.create(:user)
          @admin = FactoryGirl.create(:admin)
          # save_and_open_page
        end
  
        describe "as a regular user" do
          it 'show the course content' do
            set_user(@user)
            get :ror
            response.should redirect_to root_url
            flash[:notice].should have_content "You must be an authorized user to do that"
          end
        end
  
        describe "as an admin" do
          it 'shows the course content' do
            set_user(@admin)
            get :ror
            response.should render_template :ror_content
            response.body.should have_content 'RoR Course'
          end
          
        end
  
      end
  
    end
  
  end
end
