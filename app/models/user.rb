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
  
  def premium?
    role == 'premium'
  end
end
