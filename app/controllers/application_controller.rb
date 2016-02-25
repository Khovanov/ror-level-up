require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render 'shared/exception', status: :forbidden, locals: {exception: exception} }
      format.js { render 'shared/exception', status: :forbidden, locals: {exception: exception} }
      format.html { render 'shared/exception', status: :forbidden, locals: {exception: exception} }
      # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      # format.js { render nothing: true, error: exception.message }
      # format.html { redirect_to :back, alert: exception.message }
    end
    # redirect_to root_url, alert: exception.message 
  end

  check_authorization unless: :devise_controller?
end
