class VisitorQuestionsController < ApplicationController
  def ask
    @question = VisitorQuestion.new
    @questions = VisitorQuestion.responded
    # render :partial => 'ask_form'
  end
  def create
    @question = VisitorQuestion.new(params[:visitor_question])
    if @question.save
      redirect_to :back
    else
      render :text => 'fail'
    end
  end
  def not_respond
    @questions = VisitorQuestion.not_respond
  end
  def respond
    @question = VisitorQuestion.find(params[:id])
    render :partial => 'respond_form'
  end
  def responded
    @question = VisitorQuestion.find(params[:id])
    if @question.update_attribute('respond', params[:visitor_question][:respond])
      redirect_to '/question/respond'
    else
      render :text => 'fail'
    end
  end
end
