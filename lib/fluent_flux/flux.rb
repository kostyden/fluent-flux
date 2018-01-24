class Flux
  def initialize(function, *args)
    @current = -> { function.call(*args) }
  end

  def self.begin_with(function, *args)
    Flux.new(function, *args)
  end
  
  def then(function, *args)
    result = @current.call
    args << result
    Flux.begin_with(function, *args)
  end

  def call
    @current.call
  end

  singleton_class.send(:alias_method, :with, :begin_with)
end
