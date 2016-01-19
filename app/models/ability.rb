class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super?
      can :manage, :all
    elsif user.store_manager?||user.superadmin?
      can :manage, :all
    elsif user.front_desk?
      can :read, Member
      can :read, MembershipCardType
      can :read, Product
      can :read, MembershipCard
      can [:read, :update], Checkin
      can [:read, :create, :update, :destroy], SBanner
      can [:read, :update], Profile
    end
  end
end
