class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_user, root: 'user'
  end

  def others
    respond_with User.where.not(id: current_user), root: 'users'
  end
end
