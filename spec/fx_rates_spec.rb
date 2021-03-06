require "bigdecimal"

RSpec.describe FxRates::ExchangeRate do
    before(:each) do
      @date = Date.strptime("2018-02-01", '%Y-%m-%d')
      @data_src_double = double("Rates Data Source")
      allow(@data_src_double).to receive(:load_rates)
    end

    it "raises ArgumentError when called without a date" do
      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect{tested.at(nil, "USD", "EUR")}.to raise_error(ArgumentError)
    end

    it "raises ArgumentError when called without a from currency" do
      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect{tested.at(@date, nil, "EUR")}.to raise_error(ArgumentError)
    end

    it "raises ArgumentError when called without a to currency" do
      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect{tested.at(@date, "EUR", nil)}.to raise_error(ArgumentError)
    end

    it "returns 1 for same from and to ccy" do
      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect(tested.at(@date, "USD", "USD")).to eql(BigDecimal("1"))
    end

    it "raises error when there is no rate for from currency" do
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).and_return(nil)

      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect{tested.at(@date, "USD", "ZAR")}.to raise_error(FxRates::RateNotFoundError)
    end

    it "raises error when there is no rate for to currency" do
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).and_return(nil)

      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect{tested.at(@date, "ZAR", "CHF")}.to raise_error(FxRates::RateNotFoundError)
    end

    it "converts correctly for known currencies" do
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).with(@date, "USD").and_return("2")
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).with(@date, "ZAR").and_return("1")

      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect(tested.at(@date, "USD", "ZAR")).to eq(BigDecimal("0.5"))
    end

    it "is case insensitive for currencies" do
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).with(@date, "EUR").and_return("2")
      allow(@data_src_double).to receive(:rate_for_date_and_ccy).with(@date, "ZAR").and_return("4")

      tested = FxRates::ExchangeRate.new(@data_src_double)

      expect(tested.at(@date, "eur", "ZaR")).to eq(BigDecimal("2"))
    end
end
