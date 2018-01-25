require "fluent_flux"

RSpec.describe "Flux tests" do
  it "new should be private" do
    flux_new = -> { Flux.new(nil, nil) }
    expect(flux_new).to raise_error(NoMethodError)
  end
end