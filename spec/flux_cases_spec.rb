require "fluent_flux"

RSpec.describe "Flux tests" do
  let(:load_base_salary) {-> (number) { number * 100 }}
  let(:validate_base) {-> (limit, salary) { salary < limit ? FluxResult.failure(salary) : FluxResult.success(salary) }}
  let(:add_bonus) {-> (bonus, salary) { FluxResult.success(bonus + salary) }}
  let(:reduce_taxes) {-> (tax, salary) { salary * (1.0 - tax/100.0) }}
  let(:print) {-> (salary) { "total: #{salary}" }}

  it "on successful path should return expected value" do
    expected = "total: 1500.0"

    actual = Flux.begin_with(load_base_salary, 10.0)
                 .try(validate_base, 700.0)
                 .on_success(add_bonus, 1000.0)
                 .always(reduce_taxes, 25.0)
                 .then(print)
                 .call

    expect(actual).to eq(expected)
  end

  it "when on_failed called after on_success during successful path" do
    above_limit = -> (limit, salary) { salary > limit }
    reduce = -> (amount, salary) { salary - amount }

    actual = Flux.begin_with(load_base_salary, 10.0)
                 .success_when(above_limit, 900)
                 .on_success(reduce, 1000.0)
                 .on_failure(reduce, 20)
                 .call

    expect(actual).to eq(0)
  end

  it "when on_success called after on_failure during failed path" do
    above_limit = -> (limit, salary) { salary > limit }
    reduce = -> (amount, salary) { salary - amount }

    actual = Flux.begin_with(load_base_salary, 5.0)
                 .success_when(above_limit, 2000)
                 .on_failure(reduce, 20)
                 .on_success(reduce, 1000)
                 .call

    expect(actual).to eq(480)
  end
end