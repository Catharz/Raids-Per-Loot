# @author Craig Read
#
# ExternalData is used to store data for characters and
# items from the Sony data service at http://data.soe.com
class HashParser
  def initialize(hash)
    if hash.has_key? 'class'
      hash['archetype'] = hash['class']
      hash.delete 'class'
    end
    hash.each do |k, v|
      (v.is_a? Hash) ? nv = HashParser.new(v) : nv = v

      ## create and initialize an instance variable for this key/value pair
      self.instance_variable_set("@#{k}", nv)
      ## create the getter that returns the instance variable
      self.class.send(:define_method, k, proc { self.instance_variable_get("@#{k}") })
      ## create the setter that sets the instance variable
      self.class.send(:define_method, "#{k}=", proc { |nnv| self.instance_variable_set("@#{k}", nnv) })
      ## Allow for data to be missing.  This does will NOT resolve to multiple levels
      self.class.send(:define_method, :method_missing, proc { |meth, *args| 'N/A' })
    end
  end
end