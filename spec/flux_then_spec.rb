require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "then - should pass current result as last argument to given function" do
    sum = -> (a, b) { a + b }
    it "and no arguments" do
      multiply_by_3 = -> (value) { value * 3 }
      actual = Flux.begin_with(sum, 12, 13).then(multiply_by_3).call
  
      expect(actual).to eq(75)
    end

    it "and one argument" do
      multiply = -> (a, b) { a * b }
      actual = Flux.begin_with(sum, 2, 10).then(multiply, 5).call
  
      expect(actual).to eq(60)
    end

    it "and two arguments" do
      multiply_and_reduce = -> (a, b, c) { a * b - c }
      actual = Flux.begin_with(sum, 45, 55).then(multiply_and_reduce, 10, 12)
  
      expect(actual.call).to eq(20)
    end

    it "and four arguments" do
      calculate = -> (a, b, c, factor, reducer) { ((a + (b - c)) * factor) - reducer }
      actual = Flux.begin_with(sum, 20, 30).then(calculate, 10, 12, 2, 5).call
  
      expect(actual).to eq(50)
    end
  end
end