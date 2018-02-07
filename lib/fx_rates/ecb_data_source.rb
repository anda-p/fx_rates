require 'nokogiri'
require 'open-uri'
require 'concurrent'

require_relative 'rates_data_source'

# Class representing a data source for exchange rates from the European Central Bank
class ECBRatesDataSource < RatesDataSource
    # The URL to the ECB rates data
    RATES_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
    
    # All the rates data
    attr_reader :rates

    # Initializes the rates data as a thread-safe Hash and sets the base ccy which 
    # is EUR in this case. The base currency is used to artificially add a rate of 1 
    # in the data set (in case it's not present) to make the calculation easier
    def initialize
        @rates = Concurrent::Hash.new
        @base_ccy = "EUR"
    end

    # Downloads and parses the rates data from the ECB website
    def load_rates
        doc = Nokogiri::XML(open(RATES_URL))

        doc.xpath("//xmlns:Cube[@time]").each do |day_node|
            date = day_node.xpath("@time")
            parsed_date = Date.strptime(date.to_s, '%Y-%m-%d')

            @rates[parsed_date] = Concurrent::Hash.new
            # the base currency will always have rate 1 with itself
            @rates[parsed_date][@base_ccy] = "1"

            day_node.element_children.each do |ccy_node|
                currency = ccy_node.xpath("@currency").text
                rate = ccy_node.xpath("@rate").text

                @rates[parsed_date][currency] = rate
            end    
        end 
    end
    
    def rate_for_date_and_ccy(date, ccy)
        @rates[date][ccy]
    end
end