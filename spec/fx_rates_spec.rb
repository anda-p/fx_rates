require 'bigdecimal'

RSpec.describe FxRates do
  before(:each) do
    @date = Date.strptime("2018-02-01", '%Y-%m-%d')
    @data_src_double = double("Rates Data Source")
    allow(@data_src_double).to receive(:load_data)
  end

  it "returns 1 for same from and to ccy" do
    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect(tested.at(@date, "USD", "USD")).to eql(BigDecimal("1"))
  end

  it "raises ArgumentError when no date is specified" do
    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect{tested.at(nil, "USD", "EUR")}.to raise_error(ArgumentError)
  end

  it "converts correctly" do
    allow(@data_src_double).to receive(:rates).and_return({@date => {"ZAR" => "4", "USD" => "2"}})

    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect(tested.at(@date, "USD", "ZAR")).to eq(BigDecimal("2"))
  end

  it "is case insensitive for currencies" do
    allow(@data_src_double).to receive(:rates).and_return({@date => {"ZAR" => "4", "EUR" => "1"}})

    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect(tested.at(@date, "eur", "ZaR")).to eq(BigDecimal("4"))
  end
end
