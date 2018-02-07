require "fx_rates/version"
require "fx_rates/ecb_data_source"
require "fx_rates/rates_data_source"

require "bigdecimal"

module FxRates
  # Raised when a rate for the from_ccy or to_ccy is not found in the data or there is no data
  # for a particular date 
  class RateNotFoundError < StandardError
    def initialize(from_ccy, to_ccy)
        @from_ccy = from_ccy
        @to_ccy = to_ccy
    end    

    def message
        "Could not find rate for #{@from_ccy} to #{@to_ccy}"
    end
  end

  # Gets FX rates using a supplied data source
  class ExchangeRate
    # Data source for retrieving the exchange rates. Extends RatesDataSource
    attr_reader :rates_data_source

    # Saves the rates data sources and loads the rates
    def initialize(rates_data_source)
        @rates_data_source = rates_data_source
        @rates_data_source.load_rates
    end

    # Returns the exchange rate between from_ccy to to_ccy on the specified date
    # 
    # An ArgumentError is raised when either of the arguments is nil
    # A RateNotFoundError is raised when there are no rates for the supplied date
    # or any of the currencies is not found
    #
    # The currencies are case insensitive so ExchangeRate.at(Day.today, "eur", "usd")
    # will produce the same result as ExchangeRate.at(Day.today, "EUR", "USD")
    #
    # Params:
    # [date] date object specifying the date to get the exchange rate for
    # [from_currency] string representing the currency to convert from. Format should be "USD"
    # [to_currency] string representing the currency to convert to. Format should be "USD"
    # 
    # returns a BigDecimal
    def at(date, from_ccy, to_ccy)
        if date.nil? || from_ccy.nil? || to_ccy.nil?
            raise ArgumentError.new("All arguments must be specified")
        end
        
        from_ccy_upcase = from_ccy.upcase
        to_ccy_upcase = to_ccy.upcase

        if (from_ccy_upcase == to_ccy_upcase)
            return BigDecimal.new("1")
        end

        from_rate = @rates_data_source.rate_for_date_and_ccy(date, from_ccy_upcase)
        to_rate = @rates_data_source.rate_for_date_and_ccy(date, to_ccy_upcase)

        if !from_rate.nil? && !to_rate.nil?
            return BigDecimal.new(to_rate) / BigDecimal.new(from_rate)
        else raise RateNotFoundError.new(from_ccy, to_ccy)
        end
    end

    # Loads the rates data from the supplied data source
    def load_rates
        @rates_data_source.load_rates
    end  
  end
end