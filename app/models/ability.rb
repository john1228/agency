class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?||user.super?
      can :manage, :all
    elsif user.front_desk?
      can :read, :update, Member
      can :read, MembershipCardType
      can :read, Product
      can :read, MembershipCard
      can :manager, Checkin
      can :update, Profile
    else
      can :manage, :all
    end
  end
end
