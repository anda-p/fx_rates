# Class representing a data source for exchange rates
class RatesDataSource
    # Returns a Hash of the format
    # {date => {ccy1 => rate1, ccy2 => rate2}}
    # where date is a Date and the currencies and rates are strings
    def rates
        raise NotImplementedError
    end

    # Refreshes the rates data with the latest values
    def load_rates
        raise NotImplementedError
    end 
end 