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

  it "returns counter ccy rate if from currency is base currency" do
    allow(@data_src_double).to receive(:rates).and_return({@date => {"ZAR" => "3.14"}})
    allow(@data_src_double).to receive(:base_ccy).and_return("EUR")

    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect(tested.at(@date, "EUR", "ZAR")).to eql(BigDecimal("3.14"))
  end
end
