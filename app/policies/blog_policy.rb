class BlogPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.where(user_id: @user.id)
    end
  end

  def index?
    true
  end

  def schedule?
    true
  end
end
