class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  validates :username, presence: true, uniqueness: true
  
  has_many :wikis
  
  after_initialize :init
  
  def init
    self.role ||= 'standard'
  end
  
  def admin?
    role == 'admin'
  end
  
  def standard?
    role == 'standard'
  end
  
  def premium?
    role == 'premium'
  end
  
  def upgrade
    if self.standard? #conditional statement meant to protect admin users
      self.update_attribute(:role, 'premium')
    end
  end
  
  def downgrade
    if self.premium?
      self.update_attribute(:role, 'standard')
    end
  end
end
