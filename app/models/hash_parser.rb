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
      create_instance_var k, nv
      create_getter k
      create_setter k
      create_method_missing
    end
  end

  private
  def create_instance_var key, value
    ## create and initialize an instance variable for this key/value pair
    self.instance_variable_set("@#{key}", value)
  end

  def create_getter key
    ## create the getter that returns the instance variable
    self.class.send(:define_method, key, proc { self.instance_variable_get("@#{key}") })
  end

  def create_setter key
    ## create the setter that sets the instance variable
    self.class.send(:define_method, "#{key}=", proc { |nnv| self.instance_variable_set("@#{key}", nnv) })
  end

  def create_method_missing
    ## Allow for data to be missing.  This does will NOT resolve to multiple levels
    self.class.send(:define_method, :method_missing, proc { |meth, *args| 'N/A' })
  end
end
