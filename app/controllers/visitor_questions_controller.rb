class VisitorQuestionsController < ApplicationController
  before_filter :authorize_user!, :only => [:not_respond, :respond, :responded]
  
  def index
    @question = VisitorQuestion.new
    @questions = VisitorQuestion.responded.first(10)
  end

  def create
    @question = VisitorQuestion.new(params[:visitor_question])
    if @question.save
      msg = "Thanks for your submittion"
    else
      msg = "Please provide valid email and description"
    end
    redirect_to :back, :notice => msg
  end

  def show
    @question = VisitorQuestion.find(params[:id])
  end

  def not_respond
    @questions = VisitorQuestion.not_respond
  end

  def respond
    @question = VisitorQuestion.find(params[:id])
  end

  def responded
    @question = VisitorQuestion.find(params[:id])
    respond = params[:visitor_question][:respond]
    if respond.length > 0 && @question.update_attribute('respond', respond)
      # send email to notify visitor
      QuestionMailer.responded(@question).deliver
      redirect_to not_respond_asks_path, :notice => 'Question answered'
    else
      redirect_to :back, :notice => 'Respond text too short'
    end
  end

  def page
    offset = 10*(params[:number].to_i-1)
    @questions = VisitorQuestion.responded.limit(10).offset(offset)
    ajax_no_layout
  end
  
end
