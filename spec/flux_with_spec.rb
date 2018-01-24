require "fluent_flux"

RSpec.describe "Flux tests" do
  methods = {
    :begin_with => -> (function, *args) { Flux.begin_with(function, *args) },
    :with => -> (function, *args) { Flux.with(function, *args) },
  }

  methods.each do |key, method|
    describe "#{key} - should create instance which can be called with given function" do
      it "and without arguments" do
        expected = "hello"
        say_hello = -> { expected }
        actual = method.(say_hello).call
        
        expect(actual).to eq(expected)
      end
      
      it "and one argument" do
        add10 = -> (value) { value + 10 }
        actual = method.(add10, 5).call
        
        expect(actual).to eq(15)
      end
      
      it "and two argument" do
        add = -> (a, b) { a + b }
        actual = method.(add, 5, 2).call
        
        expect(actual).to eq(7)
      end
      
      it "and four argument" do
        calculate_and_print = -> (a, b, c, suffix) { "#{a * (b + c) } #{suffix}" }
        actual = method.(calculate_and_print, 5, 2, 3, "times").call
        
        expect(actual).to eq("25 times")
      end
    end
  end
end