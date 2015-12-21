class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if current_user == @attachment.attachable.user
      @attachment.destroy 
      render :destroy
    end

    # if @attachment.destroyed?
    #   if @attachment.attachable_type == 'Question'
    #     @question = Question.find @attachment.attachable_id
    #   elsif @attachment.attachable_type == 'Answer'
    #     @answer = Answer.find @attachment.attachable_id
    #   end 
    # end
    # redirect_to :back
  end

  private

  def load_attachment
    @attachment = Attachment.find params[:id]
  end
end
