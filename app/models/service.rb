# @author Craig Read
#
# Service represents the OmniAuth service
# provider such as Google, Facebook, etc
class Service < ActiveRecord::Base
  belongs_to :user

  attr_accessible :provider, :uid, :uname, :uemail
  validates_presence_of :provider, :uid, :uname, :uemail
end
