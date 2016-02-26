class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!
  respond_to :json

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    # https://github.com/ryanb/cancan/wiki/Ability-for-Other-Users
    @current_ability ||= Ability.new(current_resource_owner)
  end
end

