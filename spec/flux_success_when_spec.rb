require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "success_when - " do
    let(:get_first_number) { -> (numbers) { numbers.first }}
    let(:add) { -> (a, b) { a + b }}
    let(:square_root) { -> (number) { Math.sqrt(number) }}
    
    describe "wrap return value based on the given predicate" do
      let(:positive) { -> (number) { number > 0 }}

      it "when true into successful result" do  
        actual = Flux.begin_with(get_first_number, [15, 16, 17, 18])
                     .then(add, 10)
                     .success_when(positive)
                     .on_success(square_root)
                     .call
    
        expect(actual).to be(5.0)
      end
  
      it "when false into failed result" do
        actual = Flux.begin_with(get_first_number, [0, 1, 2, 3, 4])
                     .then(add, -8)
                     .success_when(positive)
                     .on_success(square_root)
                     .call
    
        expect(actual.value).to be(-8)
      end
    end

    describe "wrap return value based on the given predicate with" do
      let(:more_then) { -> (limit, value) { value > limit }}

      it "two arguments and when true into successful result" do  
        actual = Flux.begin_with(get_first_number, [0, 2])
                     .then(add, 49)
                     .success_when(more_then, 0)
                     .on_success(square_root)
                     .call
    
        expect(actual).to be(7.0)
      end
  
      it "one argument and when false into failed result" do
        actual = Flux.begin_with(get_first_number, [7, 1])
                     .then(add, -8)
                     .success_when(more_then, -1)
                     .on_success(square_root)
                     .call
    
        expect(actual.value).to be(-1)
      end
    end
  end
end