require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "success_when - " do
    let(:get_first_number) { -> (numbers) { numbers.first }}
    let(:add) { -> (a, b) { a + b }}
    let(:positive) { -> (number) { number > 0 }}
    let(:square_root) { -> (number) { Math.sqrt(number) }}

    describe "wrap return value based on the given predicate" do
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
  end
end