class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super?
      can :manage, :all
    elsif user.store_manager?
      can :manage, :all
    elsif user.front_desk?
      can :read, MembershipCardType
      can :read, Product
      can :read, MembershipCard
      can :manager, Checkin
      can :update, Profile
    end
  end
end
