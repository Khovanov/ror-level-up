module ControllerMacros
  def login(user)
    # before do
    # @user = create(:user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    # sign_in @user
    sign_in user
    # end
  end
end
