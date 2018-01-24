require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "start - " do
    it "should create instance which can be called with given function and one argument" do
      add10 = -> (value) { value + 10 }
      actual_start = Flux.begin_with(add10, 5)
  
      expect(actual_start.call).to eq(15)
    end

    it "should create instance which can be called with given function and two argument" do
      substract = -> (a, b) { a - b }
      actual_start = Flux.begin_with(substract, 5, 2)
  
      expect(actual_start.call).to eq(3)
    end

    it "should create instance which can be called with given function and four argument" do
      calculate = -> (a, b, c, suffix) { "#{a * (b + c) } #{suffix}" }
      actual_start = Flux.begin_with(calculate, 5, 2, 3, "times")
  
      expect(actual_start.call).to eq("25 times")
    end
  end

  describe "then - should pass result of Flux to last argument of given function" do
    sum = -> (a, b) { a + b }
    it "and no arguments" do
      multiply_by_3 = -> (value) { value * 3 }
      actual_then = Flux.begin_with(sum, 12, 13).then(multiply_by_3)
  
      expect(actual_then.call).to eq(75)
    end

    it "and one argument" do
      multiply = -> (a, b) { a * b }
      actual_then = Flux.begin_with(sum, 2, 10).then(multiply, 5)
  
      expect(actual_then.call).to eq(60)
    end

    it "and two arguments" do
      calculate = -> (a, b, c) { a * b - c }
      actual_start = Flux.begin_with(sum, 45, 55).then(calculate, 10, 12)
  
      expect(actual_start.call).to eq(20)
    end

    it "and four arguments" do
      calculate = -> (a, b, c, factor, reducer) { ((a + (b - c)) * factor) - reducer }
      actual_start = Flux.begin_with(sum, 20, 30).then(calculate, 10, 12, 2, 5)
  
      expect(actual_start.call).to eq(50)
    end
  end
end