class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.save
    redirect_to @question
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
