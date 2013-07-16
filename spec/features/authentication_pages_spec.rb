require 'spec_helper'

include Warden::Test::Helpers

describe "Authentication" do

  describe "authorization" do

    subject { page }

    describe "for non-signed-in users" do
      describe "when visiting the ror-course root path" do
        before { visit home_ror_path }

        it { should have_selector('.alert', text: "sign in first") }
      end
    end

    describe "for users signed-in" do

      @user = FactoryGirl.create(:user)
      # let(:admin) { FactoryGirl.create(:admin) }

      describe "as a regular user" do

        login_as(@user)
        it { should_not have_selector('.alert', text: "sign in first") }

      end

      # describe "when visiting the ror-course root path" do

      # end

    end

  end
end