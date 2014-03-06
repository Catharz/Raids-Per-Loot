# @author Craig Read
#
# VersionsHelper provides a means to view
# the changes from one version of a model
# to the other, as tracked by paper trail
module VersionsHelper
  def changes(version, excluded_columns = %w{updated_at})
    return update_changes(version, excluded_columns) if version.event == 'update'
    return creation_changes(version, excluded_columns) if version.event == 'create'
    return deletion_changes(version, excluded_columns) if version.event == 'destroy'
    []
  end

  private

  def update_changes(version, excluded_columns)
    changed_values = []
    new_item = version.item
    old_item = version.previous_version
    differences = old_item.attributes.diff(new_item.attributes)
    differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
      changed_values << {key: key, old: old_item[key], new: new_item[key]}
    end
    changed_values
  end

  def creation_changes(version, excluded_columns)
    changed_values = []
    differences = version.item.attributes
    differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
      changed_values << {key: key, old: nil, new: version.item[key]}
    end
    changed_values
  end

  def deletion_changes(version, excluded_columns)
    changed_values = []
    deleted_item = version.reify
    differences = deleted_item.attributes.diff({})
    differences.keys.reject { |k| excluded_columns.include? k }.each do |key|
      changed_values << {key: key, old: deleted_item[key], new: nil}
    end
    changed_values
  end
end
