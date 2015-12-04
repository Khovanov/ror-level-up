class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy]

  def create
    # @answer = @question.answers.build(answer_params)
    # @answer.save
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    # redirect_to @question
  end

  def destroy
    if current_user == @answer.user 
      @answer.destroy
      redirect_to @question
    else
      # redirect_to question_path(@question)
      redirect_to @question
    end
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
    params.require(:answer).permit(:body)
  end
end
