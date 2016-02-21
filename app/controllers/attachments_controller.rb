class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  respond_to :js
  authorize_resource
  
  def destroy
    return unless current_user == @attachment.attachable.user
    respond_with @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find params[:id]
  end
end
