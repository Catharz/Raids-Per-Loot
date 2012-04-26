class Adjustment < ActiveRecord::Base
  belongs_to :adjustable, :polymorphic => true
end
