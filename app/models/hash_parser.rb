class HashParser
  def initialize(hash)
    if hash.has_key? 'class'
      hash['archetype'] = hash['class']
      hash.delete 'class'
    end
    hash.each do |k, v|
      if v.is_a? Hash
        nv = HashParser.new(v)
      else
        nv = v
      end
      self.instance_variable_set("@#{k}", nv) ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc { self.instance_variable_get("@#{k}") }) ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc { |nnv| self.instance_variable_set("@#{k}", nnv) }) ## create the setter that sets the instance variable
      self.class.send(:define_method, :method_missing, proc { |meth, *args| 'N/A' }) ## Allow for data to be missing.  This does will NOT resolve to multiple levels
    end
  end
end