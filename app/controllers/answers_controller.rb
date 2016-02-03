class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy, :update, :best]

  def create
    # @answer = @question.answers.build(answer_params)
    # @answer.save
    # @answer = @question.answers.create(answer_params.merge(user: current_user))
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      PrivatePub.publish_to "/questions/#{@answer.question.id}/answers", answer: @answer.to_json
    end
    # redirect_to @question
  end

  def update
    @answer.update(answer_params) if current_user == @answer.user
  end

  def destroy
    @answer.destroy if current_user == @answer.user
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
