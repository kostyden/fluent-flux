class Flux
  private_class_method :new
  
  def initialize(function, *args)
    @current = -> { function.call(*args) }
  end
  
  def self.begin_with(function, *args)
    new(function, *args)
  end
  
  def then(function, *args)
    args << @current.call
    Flux.with(function, *args)
  end

  def success_when(predicate, *args)
    value = @current.call 
    args << value
    result = predicate.call(*args) ? FluxResult.success(value) : FluxResult.failure(value)
    Flux.with(-> { result })
  end

  def on_success(function, *args)
    result = @current.call
    return Flux.with(-> { result }) unless result.success?

    args << result.value
    Flux.with(function, *args)
  end

  def always(function, *args)
    result = @current.call
    value = result.is_a?(FluxResult) ? result.value : result
    args << value
    Flux.with(function, *args)
  end
  
  def call
    @current.call
  end

  private

  singleton_class.send(:alias_method, :with, :begin_with)
  singleton_class.send(:alias_method, :try_with, :begin_with)

  alias_method(:try, :then)
end
