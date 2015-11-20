class WikiPolicy < ApplicationPolicy

  def index?
    true
  end
  
  def show?
    !record.private? || (user.present? && (user.premium? || user.admin?))
  end
  
  def create?
    record.private ? (user.present? && (user.premium? || user.admin?)) : user.present?
  end
  
  def update?
    record.private ? (user.present? && (user.premium? || user.admin?)) : user.present?
  end
  
  def destroy?
    record.private ? (user.present? && (user.premium? || user.admin?)) : user.present?
  end
end