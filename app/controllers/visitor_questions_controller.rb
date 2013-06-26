class VisitorQuestionsController < ApplicationController
  def ask
    @question = VisitorQuestion.new
    @questions = VisitorQuestion.responded
    # render :partial => 'ask_form'
  end
  def create
    @question = VisitorQuestion.new(params[:visitor_question])
    if @question.save
      msg = "Thanks for your submittion"
    else
      msg = "Please provide valid email id and description"
    end
    redirect_to :back, :notice => msg
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
    if respond.length > 0 && @question.update_attribute('respond', )
      # send email to notify visitor
      redirect_to '/question/respond', :notice => 'question answered'
    else
      redirect_to :back, :notice => 'respond text too short'
    end
    
  end
end
