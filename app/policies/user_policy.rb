class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.role == "admin"
  end

  def update?
    user.role == "admin" || record.id == user.id
  end

  def delete?
    user.role == "admin"
  end
end
