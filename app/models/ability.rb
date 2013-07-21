class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= NullUser.new

    if user.role? :admin
     can :manage, :all
    end
    if user.role? :raid_leader
       can :manage, Raid
       can :manage, Instance
       can :manage, Drop
       can :manage, Item
       can :manage, ItemsSlot
       can :manage, PlayerRaid
       can :manage, CharacterInstance
    end
    if user.role? :officer
       can :manage, Player
       can :manage, Character
    end
    if user.role? :raider
      can :read, Raid
      can :read, Instance
      can :read, Player
      can :read, Character
      can :read, Drop
      can :read, Item
      can :read, User do |u|
        u == user
      end
    end
    if user.role? :guest
      can :read, Raid
      can :read, Instance
      can :read, Player
      can :read, Character
      can :read, Drop
      can :read, Item
    end
  end
end