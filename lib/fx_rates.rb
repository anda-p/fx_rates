require "fx_rates/version"
#require "fx_rates/ecb_data_source"
#require "fx_rates/rates_data_source"

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
      end

      # this goes in the exchange_rate class
      def calculate_rate(date, from_ccy, to_ccy)
          from_ccy_up = from_ccy.upcase
          to_ccy_up = to_ccy.upcase

          if (from_ccy_up == to_ccy_up)
              return BigDecimal.new("1.0")
          end

          day_data = @rates_data_source.rates_by_date(date)
          base_ccy = @rates_data_source.base_ccy
          
          if !day_data.nil?
              from_rate = day_data[from_ccy_up] 
              to_rate = day_data[to_ccy_up]

              if from_ccy_up == base_ccy
                  if !to_rate.nil?
                      return BigDecimal(day_data[to_ccy_up])
                  else raise RateNotFoundError.new(from_ccy, to_ccy)
                  end    
              elsif to_ccy_up == base_ccy
                  if !from_rate.nil?
                      return BigDecimal.new("1.0").div(BigDecimal.new(from_rate))
                  else raise RateNotFoundError.new(from_ccy, to_ccy)
                  end    
              else        
                  if !from_rate.nil? && !to_rate.nil?
                      return BigDecimal.new(to_rate).div(BigDecimal.new(from_rate))
                  else raise RateNotFoundError.new(from_ccy, to_ccy)
                  end
              end    
          else
              raise RateNotFoundError.new(from_ccy, to_ccy)
          end

          return nil
      end     
  end
end