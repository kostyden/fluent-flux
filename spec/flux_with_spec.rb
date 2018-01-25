require "fluent_flux"

RSpec.describe "Flux tests" do
  methods = {
    :begin_with => -> (function, *args) { Flux.begin_with(function, *args) },
    :with => -> (function, *args) { Flux.with(function, *args) },
  }

  methods.each do |key, method|
    describe "#{key} - should create instance which can be called with given function" do
      it "without arguments" do
        expected = "hello"
        say_hello = -> { expected }

        actual = method.(say_hello).call
        
        expect(actual).to eq(expected)
      end
      
      it "with four arguments" do
        calculate_and_print = -> (a, b, c, suffix) { "#{a * (b + c) } #{suffix}" }
        
        actual = method.(calculate_and_print, 5, 2, 3, "times").call
        
        expect(actual).to eq("25 times")
      end
    end
  end
end