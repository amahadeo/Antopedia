class Wiki < ActiveRecord::Base
  belongs_to :user
  
  validates :title, presence: true
  validates :body, presence: true
  
  scope :visible_to, -> (user) { (user && (user.premium? || user.admin?)) ? all : where(private: false) }
  
  def make_public
    update_attribute(:private, false)
  end
end
