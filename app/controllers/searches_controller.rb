class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if Search.params_valid?(params[:query], params[:options])
      @search = Search.main(params[:query], params[:options]) 
      respond_with @search
    else
      flash[:notice] = "Invalid query"
      redirect_to :back
    end
  end
end
