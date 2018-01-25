require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "try_with - should create instance which can be called with given function" do
    it "without arguments" do
      expected = "expected"
      get_text = -> { FluxResult.success(expected) }

      actual = Flux.try_with(get_text).call
      
      expect(actual.value).to eq(expected)
    end
    
    it "with one argument" do
      reduce100 = -> (value) { FluxResult.failure(value - 100) }

      actual = Flux.try_with(reduce100, 234).call
      
      expect(actual.value).to eq(134)
    end
    
    it "with two arguments" do
      concat = -> (a, b) { FluxResult.success("#{a}#{b}") }

      actual = Flux.try_with(concat, "test", "ok").call
      
      expect(actual.value).to eq("testok")
    end
    
    it "with four argument" do
      join_numbers = -> (a, b, c, d) { FluxResult.failure("#{a}, #{b}, #{c}, #{d}") }

      actual = Flux.try_with(join_numbers, 1, 2, 3, 4).call
      
      expect(actual.value).to eq("1, 2, 3, 4")
    end
  end
end