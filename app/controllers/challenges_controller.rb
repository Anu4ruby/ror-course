class ChallengesController < ApplicationController
  def new
    @question = Question.new(qtype:params[:type])
    # @question.type = 'text'#'single-select'
    if @question.type?('text')
      @question.answers.new
    else
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
end
