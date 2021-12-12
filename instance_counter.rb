module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  @instances = 0

  module ClassMethods
    def initialize
      self.instances +=1
    end

    protected

    def instances
      return @instances
    end
  end

  module InstanceMethods
  
    def register_instance
      self.class.send :instances
    end
  end

end