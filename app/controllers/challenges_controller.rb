class ChallengesController < ApplicationController
  before_filter :get_question, :only => [:show, :edit, :update]
  def index
    
  end
  def new
    @question = Question.new(qtype:params[:type])
    # @question.type = 'text'#'single-select'
    @question.answers.new
    if !@question.type?('text')
      5.times { @question.choices.new }
    end
    if request.xhr?
      render :layout => false
    end
  end
  def create
    @question = Question.create(params[:question])
    if @question.save
      redirect_to challenge_path(@question), :notice => 'created'
    else
      redirect_to :back, :notice => 'failed'
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
