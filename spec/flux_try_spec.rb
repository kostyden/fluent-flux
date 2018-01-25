require "fluent_flux"

RSpec.describe "Flux tests" do
  describe "try - should pass current result as last argument to given function" do
    let(:get_key) { -> { "key" }}
    let(:append) { -> (suffix, original) { FluxResult.success("#{original} -> #{suffix}") }}
    let(:insert) { -> (prefix, original) { "#{prefix}: #{original}" }}

    it "and return successful result" do
      search_value = -> (key) { FluxResult.success("#{key} of value") }

      actual = Flux.begin_with(get_key)
                   .try(search_value)
                   .on_success(append, "suffix")
                   .always(insert, "1")
                   .call
  
      expect(actual).to eq("1: key of value -> suffix")
    end

    it "and return failed result" do
      search_value = -> (key) { FluxResult.failure(key) }

      actual = Flux.begin_with(get_key)
                   .try(search_value)
                   .on_success(append, "appendix")
                   .always(insert, "0")
                   .call
  
      expect(actual).to eq("0: key")
    end
  end
end