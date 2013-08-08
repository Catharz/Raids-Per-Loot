module VersionsHelper
  def changes(old_item, new_item, excluded_columns = %w{updated_at})
    changed_values = []
    if old_item.nil?
      differences = new_item.attributes
      differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
        changed_values << {key: key, old: nil, new: new_item[key]}
      end
    else
      differences = old_item.attributes.diff(new_item.attributes)
      differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
        changed_values << {key: key, old: old_item[key], new: new_item[key]}
      end
    end
    changed_values
  end
end