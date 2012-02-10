class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me

  validates :login, :presence => true, :uniqueness => true, :immutable => true

  has_many :shoots
  has_many :shoot_logs

  class Role

    User  = "user"
    Admin = "admin"

  end
end
