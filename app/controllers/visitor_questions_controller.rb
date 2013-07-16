class VisitorQuestionsController < ApplicationController
  before_filter :authorize_user!, :except => [:ask]
  def ask
    @question = VisitorQuestion.new
    @questions = VisitorQuestion.responded.last(10).reverse
    # render :partial => 'ask_form'
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
end
