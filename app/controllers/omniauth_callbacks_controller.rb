class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :user_auth

  def facebook
  end

  def twitter
  end

  def finish_sign_in
  end

  private

  def user_auth
    # render json: request.env['omniauth.auth']
    return unless User.credentials_valid?(auth)
    user = User.find_for_oauth(auth)
    if user && user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Enter you email for confirmation'
      render 'omniauth_callbacks/form', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

end