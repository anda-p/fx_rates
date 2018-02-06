RSpec.describe FxRates do
  it "has a version number" do
    expect(FxRates::VERSION).not_to be nil
  end

  it "saves data source" do
    data_source_dbl = double
    tested = FxRates::ExchangeRate.new(data_source_dbl)

    expect(tested.rates_data_source).not_to be nil
  end
end
