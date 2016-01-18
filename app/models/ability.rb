class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?||user.super?
      can :manage, :all
    elsif user.front_desk?
      can :read, Member
      can :read, MembershipCard
    else
      can :manage, :all
    end
  end
end
