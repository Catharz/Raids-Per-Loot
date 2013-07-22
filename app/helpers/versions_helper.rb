module VersionsHelper
  def changes(old_item, new_item, excluded_columns = %w{updated_at})
    differences = old_item.attributes.diff(new_item.attributes)
    changed_values = []
    differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
      changed_values << {key: key, old: old_item[key], new: new_item[key]}
    end
    changed_values
  end
end