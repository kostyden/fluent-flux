class FluxResult
  private_class_method :new

  def self.success(value)
    new(:continue, value)
  end

  def self.failure(value)
    new(:fail, value)
  end
  
  def success?
    @result == :continue
  end
  
  def failure?
    @result == :fail
  end
  
  def value
    @value
  end
  
  private

  def initialize(result, value)
    @result = result
    @value = value
  end
end