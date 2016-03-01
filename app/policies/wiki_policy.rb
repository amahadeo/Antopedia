class WikiPolicy < ApplicationPolicy

  def index?
    true
  end
  
  def show?
    record.public? || (user.present? && (user.admin? || (user.premium? && record.user == user) || record.users.include?(user)))
  end
  
  def create?
    record.private ? (user.present? && (user.admin? || (user.premium? && record.user == user) || record.users.include?(user))) : user.present?
  end
  
  def update?
    create?
  end
  
  def destroy?
    create?
  end
  
  def collaborate?
    record.private && (user.present? && (user.admin? || (user.premium? && record.user == user) || record.users.include?(user)))
  end
  
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.present?
        if user.admin?
          wikis = scope.all #if the user is an admin, show them all the wikis
        elsif user.premium?
          all_wikis = scope.all
          all_wikis.each do |wiki|
            if wiki.public? || wiki.user == user || wiki.users.include?(user)
              wikis << wiki # if the user is premium, only show them public wikis, or private wikis they created, or private wikis they are a collaborator on
            end
          end
        else # this is the lowly standard user
          all_wikis = scope.all
          wikis = []
          all_wikis.each do |wiki|
            if wiki.public? || wiki.users.include?(user)
              wikis << wiki # only show standard users publix wikis and private wikis they are a collaborator on
            end
          end
        end
      else #public non-signed-in user
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if wiki.public?
            wikis << wiki # only show standard users publix wikis and private wikis they are a collaborator on
          end
        end
      end
     wikis # return the wikis array we've built up
    end
  end
end