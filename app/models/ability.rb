class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
        can :manage, :all
    end
  end
    private
        def basic_read_only
            can :read, Post
            can :list, Post
        end
end
