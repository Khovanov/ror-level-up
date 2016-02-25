class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :load_question, only: [:index]

  def index
    respond_with @question.answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    # respond_with @answer = @question.answers.find_by(id: params[:id])
    respond_with Answer.find(params[:id])
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end