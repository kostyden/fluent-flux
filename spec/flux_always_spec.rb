require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "always - should pass unwrapped value to given function" do
    it "when failing result" do
      failing_add = -> (a, b) { FluxResult.failure(a - b) }   
      multiply_by_10 = -> (value) { FluxResult.success(value * 10) }   
      format_result = -> (value) { "result = #{value}" }

      actual = Flux.try_with(failing_add, 23, 27)
                   .on_success(multiply_by_10)
                   .always(format_result)
                   .call

      expect(actual).to eq("result = -4")
    end

    it "when successful result" do
      successful_add = -> (a, b) { FluxResult.success(a + b) }   
      multiply_by_10 = -> (value) { FluxResult.success(value * 10) }   
      format_result = -> (value) { "result = #{value}" }

      actual = Flux.try_with(successful_add, 12, 4)
                   .on_success(multiply_by_10)
                   .always(format_result)
                   .call

      expect(actual).to eq("result = 160")    
    end
  end
end