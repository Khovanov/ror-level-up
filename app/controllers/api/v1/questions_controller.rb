class Api::V1::QuestionsController < Api::V1::BaseController
  # authorize_resource class: Question
  authorize_resource Question

  def index
    # https://github.com/rails-api/active_model_serializers/blob/master/docs/general/rendering.md#explicit-serializer
    # render json: @posts, serializer: CollectionSerializer, each_serializer: PostPreviewSerializer
    # render json: @user_post, root: "admin_post", adapter: :json
    respond_with Question.all, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    respond_with current_resource_owner.questions.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end