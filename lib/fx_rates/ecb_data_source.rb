require 'nokogiri'
require 'open-uri'

class ECBRatesDataSource < RatesDataSource
    RATES_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
    
    attr_reader :all_rates, :base_ccy

    def initialize
        @all_rates = Hash.new
        @base_ccy = "EUR"

        load_data
    end

    def load_data
        doc = Nokogiri::XML(open(RATES_URL))

        doc.xpath("//xmlns:Cube[@time]").each do |day_node|
            date = day_node.xpath("@time")

            parsed_date = Date.strptime(date.to_s, '%Y-%m-%d')
            @all_rates[parsed_date] = Hash.new

            day_node.element_children.each do |ccy_node|
                currency = ccy_node.xpath("@currency").text
                rate = ccy_node.xpath("@rate").text

                @all_rates[parsed_date][currency] = rate
            end    
        end 
    end

    def rates_by_date(date)
        @all_rates[date]
    end        
end