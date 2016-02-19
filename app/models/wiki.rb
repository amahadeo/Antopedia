class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  
  validates :title, presence: true
  validates :body, presence: true
  
  scope :visible_to, -> (user) { (user && (user.premium? || user.admin?)) ? all : where(private: false) }
  
  def make_public
    update_attribute(:private, false)
  end
  
  def public?
    !private
  end
end
