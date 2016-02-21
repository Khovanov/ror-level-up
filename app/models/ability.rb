class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :vote_up, :vote_down, :vote_cancel, to: :vote

    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :crud, [Question, Answer], user_id: user.id
    can :create, Comment 

    # can :best, Answer, question: { user_id: user.id }, !answer.best?
    can :best, Answer do |answer|
       answer.question.user_id == user.id && !answer.best?
    end

    can :vote, [Question, Answer] do |obj|
      obj.user_id != user.id
    end
    # can :vote, [Question, Answer]
    # cannot :vote, [Question, Answer], user_id: user.id

    can :destroy, Attachment, attachable: { user_id: user.id }
  end
end
