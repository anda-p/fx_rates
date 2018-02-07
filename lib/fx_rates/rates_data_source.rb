# Class representing a data source for exchange rates
# Subclasses must implement all functions as they act only as placeholders in this class
class RatesDataSource
    # Returns all rates data
    def rates
        raise NotImplementedError
    end

    # Refreshes the rates data with the latest values
    def load_rates
        raise NotImplementedError
    end 

    # Returns the rate for a date and currency
    # 
    # Params
    # [date] a Date object representing the date to get the rate for
    # [ccy] a string of format "USD" representing the currency to get the rate for
    # 
    # Returns nil if no rate is found or the rate as a string value otherwise
    def rate_for_date_and_ccy(date, ccy)
        raise NotImplementedError
    end 
end 