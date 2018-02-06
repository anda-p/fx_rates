require 'nokogiri'
require 'open-uri'

require_relative 'rates_data_source'

class ECBRatesDataSource < RatesDataSource
    RATES_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
    
    attr_reader :rates

    def initialize
        @rates = Hash.new
        @base_ccy = "EUR"
    end

    def load_rates
        doc = Nokogiri::XML(open(RATES_URL))

        doc.xpath("//xmlns:Cube[@time]").each do |day_node|
            date = day_node.xpath("@time")

            parsed_date = Date.strptime(date.to_s, '%Y-%m-%d')
            @rates[parsed_date] = Hash.new
            @rates[parsed_date][@base_ccy] = "1"

            day_node.element_children.each do |ccy_node|
                currency = ccy_node.xpath("@currency").text
                rate = ccy_node.xpath("@rate").text

                @rates[parsed_date][currency] = rate
            end    
        end 
    end        
end