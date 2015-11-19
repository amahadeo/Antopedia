class ChargePolicy < Struct.new(:user, :charge)
  def new?
    create?
  end
  
  def create?
    user.present? && (user.standard? || user.admin?)
  end
  
  def edit?
    destroy?
  end
  
  def destroy?
    user.present? && (user.premium? || user.admin?)
  end
  
end