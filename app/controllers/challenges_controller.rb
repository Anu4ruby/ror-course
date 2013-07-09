class ChallengesController < ApplicationController
  before_filter :get_question, :only => [:show, :edit, :update]
  def index
    
  end
  def new
    @question = Question.new(qtype:params[:type]) 
    ajax_no_layout
  end
  def create
    @question = Question.create(params[:question])
    if @question.save
      redirect_to challenge_path(@question), :notice => 'created'
    else
      flash[:notice] = 'failed'
      render 'new'
    end
  end
  def show
  end
  def edit
  end
  def update
    if @question.update_attributes(params[:question])
      redirect_to :back, :notice => 'success'
    else
      redirect_to :back, :notice => 'fails: '+(@question.errors.full_messages.first if @question.errors.any?)
    end
  end
  private
  def get_question
    @question = Question.find(params[:id])
  end
  
end
