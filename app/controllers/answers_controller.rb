class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy, :update, :best]

  def create
    # @answer = @question.answers.build(answer_params)
    # @answer.save
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    # redirect_to @question
  end

  def update
    if current_user == @answer.user     
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user == @answer.user 
      @answer.destroy
    end
  end

  def best
    @answer.best! if @question.user == current_user
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    # @answer = Answer.find(params[:id])
    # @answer = @question.answers.find_by(id: params[:id])
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
