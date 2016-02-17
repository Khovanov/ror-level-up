class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :js 
  # respond_to :json, only: :create

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params) if current_user == @question.user
    respond_with @question
  end

  def destroy
    @question.destroy if current_user == @question.user
    respond_with @question
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    # PrivatePub.publish_to("/questions", question: @question.to_json) if @question.valid?
    PrivatePub.publish_to("/questions", question: @question.to_json) unless @question.errors.present?
  end
end
