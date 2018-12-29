require 'ipaddr'

class Network < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, :presence => true
  validates :address, :presence => true
  validates :netmask, :presence => true
  validate :correct_netmask

  private

  def correct_netmask
    begin
      IPAddr.new(['0.0.0.0', self.netmask].join('/'))
    rescue IPAddr::InvalidPrefixError => ex
      errors.add(:netmask, ex.message)
    end
  end
end
