module VersionsHelper
  def changes(version, excluded_columns = %w{updated_at})
    changed_values = []
    case version.event
      when 'update'
        new_item = version.item
        old_item = new_item.previous_version
        differences = old_item.attributes.diff(new_item.attributes)
        differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
          changed_values << {key: key, old: old_item[key], new: new_item[key]}
        end
      when 'create'
        differences = version.item.attributes
        differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
          changed_values << {key: key, old: nil, new: version.item[key]}
        end
      else #destroy
        deleted_item = version.reify
        differences = deleted_item.attributes.diff({})
        differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
          changed_values << {key: key, old: deleted_item[key], new: nil}
        end
    end
    changed_values
  end
end