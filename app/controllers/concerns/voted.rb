module Voted
  extend ActiveSupport::Concern

  included do 
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end


  def vote_up
    @votable.vote_up(current_user) unless current_user == @votable.user
    render 'votes/vote' 
  end

  def vote_down
    @votable.vote_down(current_user) unless current_user == @votable.user
    render 'votes/vote' 
  end

  def vote_cancel
    @votable.vote_cancel(current_user) unless current_user == @votable.user
    render 'votes/vote' 
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end