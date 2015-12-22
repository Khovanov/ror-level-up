class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  def index 
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    # @answer.attachments.build
  end

  def new
    @question = Question.new
    # @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    # @question = current_user.questions.create(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user == @question.user 
      @question.update(question_params)
    end
  end

  def destroy
    if current_user == @question.user 
      @question.destroy
      redirect_to questions_path
    else
      # redirect_to question_path(@question)
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
