class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # before_action :auth

  def facebook
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end
  def twitter
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      flash[:notice] = 'Enter you email for confirmation'
      render 'omniauth_callbacks/form', locals: { auth: auth }
    end
  end

  def finish_sign_in
    twitter
  end

  private

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

end