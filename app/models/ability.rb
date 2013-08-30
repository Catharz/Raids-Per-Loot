# @author Craig Read
#
# Ability defines the user access rights
# for each user role
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= NullUser.new

    if user.role? :raid_leader
      can :manage, Raid
      can :manage, Instance
      can :manage, Drop
      can :manage, Item
      can :manage, ItemsSlot
      can :manage, PlayerRaid
      can :manage, CharacterInstance
      can :manage, Version
    end
    if user.role? :officer
      can :manage, Player
      can :manage, Character
      can :show, Version
    end
    if user.role? :raider
      can :read, Raid
      can :read, Instance
      can :read, Player
      can :read, Character
      can :read, Drop
      can :read, Item
    end
    if user.role? :guest
      can :read, Raid
      can :read, Instance
      can :read, Player
      can :read, Character
      can :read, Drop
      can :read, Item
    end

    cannot :manage, User
    can :read, User do |u|
      u == user
    end
    can :update, User do |u|
      u == user
    end
    if user.role? :admin
      can :manage, :all
    end
  end
end