class Adjustment < ActiveRecord::Base
  belongs_to :adjustable, :polymorphic => true

  def of_type(adjustment_type)
    adjustment_type ? where(:adjustment_type => adjustment_type) : scoped
  end
end
