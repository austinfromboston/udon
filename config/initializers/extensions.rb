class Array
  def extract_options!
    return pop if last.is_a? Hash
    {}
  end
end

class Module
  # Delegate method 
  # It expects an array of arguments that contains 
  # the methods to be delegated and a hash of options
  def delegate(*methods)
    # Pop up the options hash from arguments array
    options = methods.pop
    # Check the availability of the options hash
    # and more specifically the :to option
    # Raises an error if one of them is not there
    unless options.is_a?(Hash) && to = options[:to]
      raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)."
    end

    # Make sure the :to option follows syntax rules
    # for method names 
    if options[:prefix] == true && options[:to].to_s =~ /^[^a-z_]/
      raise ArgumentError, "Can only automatically set the delegation prefix when delegating to a method."
    end

    # Set the real prefix value 
    prefix = options[:prefix] && "#{options[:prefix] == true ? to : options[:prefix]}_"

   # Here comes the magic of ruby :) 
   # Reflection techniques are used here:
   # module_eval is used to add new methods on the fly which:
   # expose the contained methods' objects
    methods.each do |method|
      module_eval("def #{prefix}#{method}(*args, &block)\n#{to}.__send__(#{method.inspect}, *args, &block)\nend\n", "(__DELEGATION__)", 1)
    end
  end
end
