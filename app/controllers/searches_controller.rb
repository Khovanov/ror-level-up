class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if params[:query].present?
      @search = Search.question(params[:query]) 
      respond_with @search
    else
      flash[:notice] = "Empty query"
      redirect_to :back
    end
  end
end
