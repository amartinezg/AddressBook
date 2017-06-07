class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, :all if user.admin?
      can :read, Organization if user.regular?
      can :manage, Contact if user.regular?
    end
  end
end
