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
  
  describe 'role' do
    before(:all) do
      @q = FactoryGirl.create(:text_question)
    end
    describe 'as an admin' do

      before(:each) do
        @admin = login_admin
      end
      
      describe 'GET new' do
        def assigned
          assigns(:question).should be_new_record
        end
        it 'from ajax call' do
          xhr :get, :new
          assigned
          @layouts.keys.should == [nil]
        end
        
        it 'from web url call' do
          get :new
          assigned
          @layouts.keys.should_not == [nil]
        end
      end
      
      describe 'GET show' do
        describe 'with valid id' do
          before(:each) do
            get :show, :id => @q.id
          end
          it 'should find the question' do
            assigns(:question).should == @q
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
        
        describe 'without valid id' do
          it 'should raise ActiveRecord::RecordNotFound' do
            lambda {get :show, :id => 0}.should raise_error ActiveRecord::RecordNotFound
          end
        end
      end
      
      describe 'GET edit' do
        describe 'with valid id' do
          it 'shows edit page' do
        
          end
        end
      
        describe 'without valid id' do
          it 'should raise ActiveRecord::RecordNotFound' do
            lambda {get :edit, :id => 0}.should raise_error ActiveRecord::RecordNotFound
          end
        end
        
      end
      
      describe 'POST create' do
        describe 'with valid attributes' do
          before(:each) do
            @question = FactoryGirl.create(:text_question)
            Question.should_receive(:new).and_return(@question)
            post :create
          end
          it 'should redirect to show page' do
            response.should redirect_to challenge_url(@question) 
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
            
        describe 'without valid id' do
          it 'should raise ActiveRecord::RecordNotFound' do
            lambda{put :update, :id => 0}.should raise_error ActiveRecord::RecordNotFound
          end
        end
        
        describe 'with valid id' do
          before(:each) do
            @question = FactoryGirl.create(:text_question)
          end
          describe 'with valid attributes' do
              before(:each) do
                @question.stub!(:update_attributes).and_return(true)
                Question.should_receive(:find).and_return(@question)
                put :update, :id => @question.id
              end
              it 'should redirect to show page' do
                response.should redirect_to @question
              end            
          end
          describe 'without valid attributes' do
            before(:each) do
              request.env["HTTP_REFERER"] = challenge_url(@question)
              @question.stub!(:update_attributes).and_return(false)
              Question.should_receive(:find).and_return(@question)
              put :update, :id => @question.id
            end
            
            it 'should redirect back' do
              redirect_back
            end
          end
        end
      end
      
      describe 'POST check_answer' do
        
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
        get :show, :id => @q.id
        redirect_home
        get :edit, :id => @q.id
        redirect_home
        put :update, :id => @q.id, :question => {:options => @q.options}
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
        get :show, :id => @q.id
        redirect_login
        get :edit, :id => @q.id
        redirect_login
        put :update, :id => @q.id, :question => {:options => @q.options}
        redirect_login
      end
    end

  end

end
