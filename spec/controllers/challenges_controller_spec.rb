require 'spec_helper'

describe ChallengesController do
  render_views
  def redirect_back
    response.should redirect_to :back
  end
            
  it 'GET index' do
    get :index
    true
  end
  describe 'without valid id' do
    it 'should raise ActiveRecord::RecordNotFound' do
      controller.should_receive(:params).and_return( { :id => 0 } )
      lambda { controller.send(:get_question) }
        .should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  let(:q) { FactoryGirl.create(:text_question) }
  
  describe 'as an admin' do

    before(:each) do
      @admin = login_admin
    end
    
    describe 'GET new' do
      def assigned
        assigns(:question).should be_new_record
      end
      it 'assigned new question' do
        get :new
        assigns(:question).should be_new_record
      end
      
      it 'no layout from ajax call' do
        xhr :get, :new
        @layouts.keys.should == [nil]
      end
      
      it 'has layout from web url call' do
        get :new
        @layouts.keys.should_not == [nil]
      end
    end
    
    describe 'GET show' do
      describe 'with valid id' do
        before(:each) do
          get :show, :id => q.id
        end
        it 'should find the question' do
          assigns(:question).should == q
        end
        context 'should show question details page' do
          it 'has title of "Challenge Question"' do
            response.body.should have_content 'Challenge Question'
          end
          it 'has New Question button/link' do
            response.body.should have_selector("a", :text => 'New Question')
          end
          it 'has Edit Question button/link' do
            response.body.should have_selector("a", :text => 'Edit Question')
          end
        end
      end
    end
    
    describe 'GET edit' do
      describe 'with valid id' do
        it 'shows edit page' do
          get :edit, :id => q.id
          response.should render_template :edit
        end
      end
    end
    
    describe 'POST create' do
      describe 'with valid attributes' do
        before(:each) do
          question = q
          Question.should_receive(:new).and_return(q)
          post :create
        end
        it 'should redirect to show page' do
          response.should redirect_to challenge_url(q) 
        end
        it 'should not render new' do
          response.should_not render_template :new
        end
      end
      describe 'without valid attributes' do
        before(:each) do
          @question = Question.new(:qtype => 'text')
          Question.should_receive(:new).and_return(@question)
          post :create
        end
        
        it 'should render new' do
          response.should render_template :new
          response.response_code.should == 422
        end
      end
    end
    
    describe 'PUT update' do
      describe 'with valid id' do
        describe 'with valid attributes' do
          before(:each) do
            q.stub!(:update_attributes).and_return(true)
            Question.should_receive(:find).and_return(q)
            put :update, :id => q.id
          end
          it 'should redirect to show page' do
            response.should redirect_to q
          end            
        end
        describe 'without valid attributes' do
          before(:each) do
            request.env["HTTP_REFERER"] = challenge_url(q)
            q.stub!(:update_attributes).and_return(false)
            Question.should_receive(:find).and_return(q)
            put :update, :id => q.id
          end
          
          it 'should redirect back' do
            redirect_back
          end
        end
      end
    end
    
    describe 'POST result' do
      it 'render result' do
        controller.should_receive(:params).at_least(1).times
          .and_return({ :answers => {} })
        post :result
        response.should render_template(:result)
      end
    end
    
  end
  
  context 'as a reqular user' do
    def redirect_home
      response.should redirect_to root_url
    end
    
    it 'should redirect to home url' do
      login_user
      get :new
      redirect_home
      post :create
      redirect_home
      get :show, :id => q.id
      redirect_home
      get :edit, :id => q.id
      redirect_home
      put :update, :id => q.id, :question => {:options => q.options}
      redirect_home
    end
  end
  
  context 'as a visitor' do
      def redirect_login
        response.should redirect_to new_user_session_url
      end
      it 'should redirect to login' do
        get :new
        redirect_login
        post :create
        redirect_login
        get :show, :id => q.id
        redirect_login
        get :edit, :id => q.id
        redirect_login
        put :update, :id => q.id, :question => {:options => q.options}
        redirect_login
      end
    end
  
end
