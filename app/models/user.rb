class User < ActiveRecord::Base
  has_many :networks
  has_many :clients
  has_secure_password

  validates :email, :presence => true, :uniqueness => true
end
