require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "try_with - should create instance which can be called with given function" do   
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
  end
end