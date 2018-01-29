require "fluent_flux"

RSpec.describe "Flux tests" do
  let(:sum) { -> (a, b) { a + b }}
  let(:positive) { -> (sum) { sum > 0 }}

  describe "on_failure - should pass value of failed result as last argument to given function" do  
    it "without arguments" do
      flip_over = -> (sum) { FluxResult.failure(-1 * sum) }
      
      actual = Flux.with(sum, 10, -110)
                   .success_when(positive)
                   .on_failure(flip_over)
                   .call
  
      expect(actual.value).to eq(100)
    end

    it "with three argument" do
      use_formula = -> (a, b, c, d) { (a + b) * (c + d) }

      actual = Flux.with(sum, 4, -15)
                   .success_when(positive)
                   .on_failure(use_formula, 2, 8, 13)
                   .call
  
      expect(actual).to eq(20)
    end
  end

  it "on_failure - should return successful result of current method" do
    use_nil = -> (sum) { nil }

    actual = Flux.with(sum, 10, 11)
                 .success_when(positive)
                 .on_failure(use_nil)
                 .call

    expect(actual.value).to eq(21)
  end
end