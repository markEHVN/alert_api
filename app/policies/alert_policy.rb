class AlertPolicy < ApplicationPolicy
  def index?
    true
  end
  def destroy?
    user&.admin? # Only admins can delete alerts
  end
end
