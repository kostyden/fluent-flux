class Flux
  def initialize(function, *args)
    @function = -> { function.call(*args) }
  end

  def self.begin_with(function, *args)
    Flux.new(function, *args)
  end

  def then(function, *args)
    result = @function.call
    args << result
    Flux.begin_with(function, *args)
  end

  def call
    @function.call
  end
end
