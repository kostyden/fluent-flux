require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "on_success - should pass successful result as last argument to given function" do
    let(:sum) { -> (a, b) { FluxResult.success(a + b) }}
    let(:flux_success_76) { Flux.try_with(sum, 24, 52) }

    it "without arguments" do
      try_multiply_by_2 = -> (result) { FluxResult.success(result.value * 2) }

      actual = flux_success_76.on_success(try_multiply_by_2).call
  
      expect(actual.value).to eq(152)
    end

    it "with two argument" do
      try_calculate = -> (a, b, result) { FluxResult.failure(a + b * result.value) }

      actual = flux_success_76.on_success(try_calculate, 5, 10).call
  
      expect(actual.value).to eq(765)
    end
  end

  it "on_success - should return failed result of current method" do
    failing_sum = -> (a, b) { FluxResult.failure(a + b) }
    save_successful_result = -> (result) { FluxResult.success("should not be called") }

    actual = Flux.try_with(failing_sum, 25, 89).on_success(save_successful_result).call

    expect(actual.value).to eq(114)
  end
end