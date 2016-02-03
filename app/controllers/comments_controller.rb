class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_commentable, only: :create #[:create, :update, :destroy]

  def create
    # @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.json do
          render :create
          # render json: @comment
          # PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
          # PrivatePub.publish_to "/questions/#{@commentable.id}/comments", comment: @comment.to_json
          PrivatePub.publish_to channel, comment: render_to_string(:create)  
            # comment: render_to_string(:create), html: render_to_string(partial: 'comments/comment.html.slim', locals: {comment: @comment}) 
            # comment: render_to_string(template: 'comments/create.json.jbuilder') 
          # render nothing: true
        end
      else
        format.json { render :error, status: :unprocessable_entity }
        # format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
        # format.js
      end
    end
  end

  private

  def channel
    "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments"
  end

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
end
