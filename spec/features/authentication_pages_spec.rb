require 'spec_helper'
include Warden::Test::Helpers

# describe "Authentication" do

# end

describe "Authorization" do

  subject { page }

  describe "when visiting the ror-course page" do
    let(:user) { FactoryGirl.create(:user, :is_admin => admin) unless admin == 0 }
    before(:each) do
      login_as(user)
      visit home_ror_path
    end
  
    describe "for non-signed-in users" do
      let(:admin) { 0 }
      it { should have_selector('.alert', text: "sign in first") }
    end

    describe "for users signed-in" do
      describe "as an admin" do
        let(:admin) { true }
        it { should have_selector('h1', text: "Course Content") }
      end
      describe "as a regular user" do
        let(:admin) { false }
        it { should_not have_selector('h1', text: "Course Content") }
      end
    end

  end

end