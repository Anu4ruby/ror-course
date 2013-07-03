class ChallengesController < ApplicationController
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
    @question = Question.find(params[:id])
  end
  def edit
    @question = Question.find(params[:id])
  end
  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      redirect_to :action => 'edit'
    else
      redirect_to :back, :notice => 'fails'
    end
  end
end
