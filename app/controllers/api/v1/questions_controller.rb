class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    # https://github.com/rails-api/active_model_serializers/blob/master/docs/general/rendering.md#explicit-serializer
    # render json: @posts, serializer: CollectionSerializer, each_serializer: PostPreviewSerializer
    # render json: @user_post, root: "admin_post", adapter: :json
    respond_with Question.all, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with Question.find(params[:id])
  end
end