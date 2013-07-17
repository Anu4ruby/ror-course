require 'spec_helper'
include Warden::Test::Helpers
describe VisitorQuestionsController do
  context 'pulic' do
    context 'GET index' do
    it 'assigns new @question' do
      get :index
      assigns(:question).should be_new_record
    end
    it 'assigns @questions with size of 10' do
      qs = []
      20.times{ qs << FactoryGirl.create(:responded_visitor_question) }
      5.times{FactoryGirl.create(:visitor_question)}
      get :index
      assigns(:questions).should =~ qs[10...20]
      assigns(:questions).size.should == 10
    end
    it 'should renders index' do
      get :index
      response.should render_template :index
    end
  end
  
  context 'POST create' do
    before(:each) do
      request.env["HTTP_REFERER"] = asks_url
    end
    it 'creates new @question' do
      post :create, :visitor_question => FactoryGirl.attributes_for(:visitor_question)
      flash[:notice].should == "Thanks for your submittion"
      response.should redirect_to asks_url
    end
    it 'fails to create new @question' do
      post :create, :visitor_question => {:email => 'abc@abc.com'}
      flash[:notice].should == "Please provide valid email and description"
      response.should redirect_to asks_url
    end
  end
  
  context 'GET show' do
    render_views
    it 'display details of the question' do
      q = FactoryGirl.create(:visitor_question)
      get :show, :id => q.id
      assigns(:question).should == q
      response.should render_template :show
      response.body.should =~ /#{q.email}/ 
      response.body.should =~ /#{q.description}/
    end
  end
  end
  
  context 'admin' do
    before(:each) do
      admin = FactoryGirl.create(:admin)
      login_as(admin, :current_user)
      get :not_respond
    end
    after(:each) do 
      Warden.test_reset! 
    end
    
    context 'GET not_respond/pending' do
      before(:all) do
        qs = []
        5.times{qs << FactoryGirl.create(:visitor_question)}
        3.times{ FactoryGirl.create(:responded_visitor_question) }
      end
      it 'should has all the questions without responded' do
        # assigns(:questions).size.should == 5
        # response.should render_template :not_respond
        response.body.should =~ /%Pending Questions%/
      end 
    end
      
  end
    
  context 'regular user' do
    before(:each) do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :current_user)
    end
    after(:each) do 
        Warden.test_reset! 
      end
    context 'GET not_respond/pending' do
      before(:each) do
        get :not_respond
      end
      it 'should redirect to sign in' do
        response.should redirect_to new_user_session_url
      end
    end
  end
    
  context 'not sign in' do
    context 'GET not_respond/pending' do
      before(:each) do
        get :not_respond
      end
      it 'should redirect to sign in' do
        response.should redirect_to new_user_session_url
      end
    end
  end
    
  
  
end
