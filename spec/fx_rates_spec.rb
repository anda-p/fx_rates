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

  it "converts correctly" do
    allow(@data_src_double).to receive(:rates).and_return({@date => {"ZAR" => "4", "USD" => "2"}})

    tested = FxRates::ExchangeRate.new(@data_src_double)

    expect(tested.at(@date, "USD", "ZAR")).to eq(BigDecimal("2"))
  end
end
