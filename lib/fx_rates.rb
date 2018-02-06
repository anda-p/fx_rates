require "fx_rates/version"
require "fx_rates/ecb_data_source"
require "fx_rates/rates_data_source"

require "bigdecimal"

module FxRates
  class RateNotFoundError < StandardError
    def initialize(from_ccy, to_ccy)
        @from_ccy = from_ccy
        @to_ccy = to_ccy
    end    

    def message
        "Could not find rate for #{@from_ccy} to #{@to_ccy}"
    end
  end

  class ExchangeRate
      attr_reader :rates_data_source

      def initialize(rates_data_source)
          @rates_data_source = rates_data_source
          @rates_data_source.load_rates
      end

      def at(date, from_ccy, to_ccy)
          if date.nil? || from_ccy.nil? || to_ccy.nil?
            raise ArgumentError.new("All arguments must be specified")
          end
            
          from_ccy_upcase = from_ccy.upcase
          to_ccy_upcase = to_ccy.upcase

          if (from_ccy_upcase == to_ccy_upcase)
              return BigDecimal.new("1")
          end

          day_data = @rates_data_source.rates[date]
          
          if !day_data.nil?
              from_rate = day_data[from_ccy_upcase] 
              to_rate = day_data[to_ccy_upcase]

              if !from_rate.nil? && !to_rate.nil?
                  return BigDecimal.new(to_rate) / BigDecimal.new(from_rate)
              else raise RateNotFoundError.new(from_ccy, to_ccy)
              end
          else
              raise RateNotFoundError.new(from_ccy, to_ccy)
          end
      end

      def load_rates
        @rates_data_source.load_rates
      end  
  end
end