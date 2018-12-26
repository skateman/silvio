require 'ipaddr'

class Client < ActiveRecord::Base
  belongs_to :network
  belongs_to :user

  validates :name, :presence => true
  validates :user, :presence => true
  validates :network, :presence => true
  validates :address, :presence => true
  validate :correct_address

  before_create { self.token = 4.times.map { SecureRandom.hex }.join if self.token.nil? }

  private

  def correct_address
    unless IPAddr.new([network.address, network.netmask].join('/')).include?(IPAddr.new(address))
      errors.add(:address, "Invalid address #{address}")
    end
  end
end
