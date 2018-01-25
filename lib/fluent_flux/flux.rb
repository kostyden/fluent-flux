class Flux
  private_class_method :new
  
  def initialize(function, *args)
    @current = -> { function.call(*args) }
  end
  
  def self.begin_with(function, *args)
    new(function, *args)
  end
  
  def then(function, *args)
    result = @current.call
    args << result
    Flux.begin_with(function, *args)
  end
  
  def call
    @current.call
  end

  private

  singleton_class.send(:alias_method, :with, :begin_with)
end
