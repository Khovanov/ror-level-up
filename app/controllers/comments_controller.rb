class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_commentable, only: :create #[:create, :update, :destroy]
  after_action :publish_comment, only: :create  

  respond_to :json
  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def set_commentable
    @commentable = commentable_klass.find(params[commentable_id])
  end

  def commentable_klass
    params[:commentable].classify.constantize
  end

  def commentable_id
    (params[:commentable].singularize + '_id').to_sym
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    PrivatePub.publish_to(@commentable.channel_path, comment: render_to_string(:create)) if @comment.valid?
  end
end
