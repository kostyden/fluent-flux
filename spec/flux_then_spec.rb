require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "then - should pass current result as last argument to given function" do
    let(:flux_24) { Flux.begin_with(-> (a, b) {a + b}, 7, 17)}

    it "without arguments" do
      multiply_by_3 = -> (value) { value * 3 }
      actual = flux_24.then(multiply_by_3).call
  
      expect(actual).to eq(72)
    end

    it "with one argument" do
      multiply = -> (a, b) { a * b }
      actual = flux_24.then(multiply, 5).call
  
      expect(actual).to eq(120)
    end

    it "with two arguments" do
      multiply_and_reduce = -> (a, b, c) { a * b - c }
      actual = flux_24.then(multiply_and_reduce, 10, 12)
  
      expect(actual.call).to eq(96)
    end

    it "with four arguments" do
      calculate = -> (a, b, c, factor, reducer) { ((a + (b - c)) * factor) - reducer }
      actual = flux_24.then(calculate, 10, 12, 2, 5).call
  
      expect(actual).to eq(76)
    end
  end
end