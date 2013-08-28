require 'digest/sha1'

# @author Craig Read
#
# User represents a user logging into the system
# via one of the OmniAuth Services
class User < ActiveRecord::Base
  has_many :services, dependent: :destroy

  attr_accessible :name, :email, :roles

  validates_presence_of :name, :email
  validates_length_of :name, minimum: 3, maximum: 100
  validates_format_of :email, with: /.+@.+\..+/i

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  ROLES = %w{admin raid_leader officer raider guest}

  def role_symbols
    roles.map(&:to_sym)
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    role_symbols.include? role
  end
end
