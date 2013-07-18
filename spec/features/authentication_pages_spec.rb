require 'spec_helper'

include Warden::Test::Helpers

# describe "Authentication" do

# end

describe "Authorization" do

  subject { page }

  describe "when visiting the ror-course page" do

    before(:each) { visit home_ror_path }

    describe "for non-signed-in users" do
      it { should have_selector('.alert', text: "sign in first") }
    end

    describe "for users signed-in" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        login_as(@user)
        visit home_ror_path
        # save_and_open_page
      end

      describe "as a regular user" do
        it { should have_selector('h1', text: "Course Content") }
      end

      describe "as an admin" do
        # before do
        #   @user.admin true
        #   @user.save
        # end
        it { should have_selector('h1', text: "Course Content") }
      end

    end

  end

end