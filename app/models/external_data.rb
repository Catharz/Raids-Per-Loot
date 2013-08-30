# @author Craig Read
#
# ExternalData is used to store data for characters and
# items from the Sony data service at http://data.soe.com
class ExternalData < ActiveRecord::Base
  serialize :data, Hash
  belongs_to :character, :polymorphic => :true
  belongs_to :item, :polymorphic => :true

  def data
    read_attribute(:data) || write_attribute(:data, {})
  end
end