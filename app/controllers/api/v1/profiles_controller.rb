class Api::V1::ProfilesController < Api::V1::BaseController
  # authorize_resource class: User
  authorize_resource User

  def me
    respond_with current_resource_owner, root: 'user'
  end

  def others
    respond_with User.where.not(id: current_resource_owner), root: 'users'
  end
end
