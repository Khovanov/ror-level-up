class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question
  # before_action :load_answer, only: [:destroy, :update, :best]
  before_action :load_answer, except: :create
  after_action :publish_answer, only: :create

  respond_to :js 
  # respond_to :json, only: :create
  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params) 
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def best
    @answer.best!
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

  def publish_answer
    PrivatePub.publish_to("/questions/#{@answer.question.id}/answers", answer: @answer.to_json) unless @answer.errors.present?
  end
end
