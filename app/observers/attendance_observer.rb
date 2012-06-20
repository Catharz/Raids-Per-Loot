class AttendanceObserver < ActiveRecord::Observer
  observe :character, :player, :character_instance

  def before_save(model)
    update_attendance(model) if model.respond_to? :instances_count
  end

  def after_save(model)
    update_attendance(model.character) if model.respond_to? :character
    update_attendance(model.player) if model.respond_to? :player
  end

  private

  def update_attendance(model)
    if model
      model.instances_count = model.instances.count + model.adjustments.where(:adjustment_type => "Instances").sum(:amount)
      model.raids_count = model.raids.count + model.adjustments.where(:adjustment_type => "Raids").sum(:amount)
    end
  end
end
