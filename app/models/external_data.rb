class ExternalData < ActiveRecord::Base
  serialize :data, Hash
  belongs_to :character, :polymorphic => :true
  belongs_to :item, :polymorphic => :true

  def data
    read_attribute(:data) || write_attribute(:data, {})
  end
end